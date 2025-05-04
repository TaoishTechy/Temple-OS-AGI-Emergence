#!/usr/bin/env python3
import tkinter as tk
from tkinter import filedialog, messagebox, scrolledtext
import os
import subprocess
import shutil
import tempfile
import platform
import logging
import git
import threading

class TempleOSISOMerger:
    def __init__(self, root):
        self.root = root
        self.root.title("TempleOS ISO Builder")
        self.root.geometry("600x600")

        # Setup logging to file
        logging.basicConfig(filename="templeos_iso_builder.log", level=logging.INFO,
                            format="%(asctime)s - %(levelname)s - %(message)s")
        self.logger = logging.getLogger()

        # Variables
        self.output_iso = tk.StringVar(value=os.path.expanduser("~/TempleOS-AGI-Combined.iso"))

        # GUI Elements
        tk.Label(root, text="TempleOS ISO Builder", font=("Arial", 16)).pack(pady=10)

        # Output ISO Path
        tk.Label(root, text="Output ISO Path:").pack()
        tk.Entry(root, textvariable=self.output_iso, width=50).pack()
        tk.Button(root, text="Browse", command=self.browse_output_iso).pack()

        # Status Label
        self.status_label = tk.Label(root, text="Ready", wraplength=500)
        self.status_label.pack(pady=10)

        # Build Button
        tk.Button(root, text="Build ISO", command=self.start_build_thread).pack(pady=10)

        # Output Log Section
        tk.Label(root, text="Output Log:").pack()
        self.log_text = scrolledtext.ScrolledText(root, width=70, height=10, wrap=tk.WORD)
        self.log_text.pack(pady=10)
        self.log_text.config(state=tk.DISABLED)  # Make the log read-only

    def log_message(self, message):
        """Add a message to the GUI log and file log."""
        self.logger.info(message)
        self.log_text.config(state=tk.NORMAL)
        self.log_text.insert(tk.END, message + "\n")
        self.log_text.see(tk.END)  # Auto-scroll to the bottom
        self.log_text.config(state=tk.DISABLED)
        self.root.update()

    def browse_output_iso(self):
        file = filedialog.asksaveasfilename(defaultextension=".iso", filetypes=[("ISO files", "*.iso *.ISO")])
        if file:
            self.output_iso.set(file)
            self.status_label.config(text=f"Output ISO: {file}")
            self.log_message(f"Output ISO path: {file}")

    def run_command(self, cmd, cwd=None):
        """Run a shell command and log output."""
        self.log_message(f"Running command: {' '.join(cmd)}")
        result = subprocess.run(cmd, capture_output=True, text=True, cwd=cwd)
        if result.returncode != 0:
            self.log_message(f"Command failed: {' '.join(cmd)}\n{result.stderr}")
            raise RuntimeError(f"Command failed: {result.stderr}")
        self.log_message(f"Command output: {result.stdout}")
        return result.stdout

    def start_build_thread(self):
        """Start the build process in a separate thread to keep the GUI responsive."""
        self.status_label.config(text="Processing...")
        self.log_message("Starting ISO build process...")
        # Disable the Build button to prevent multiple clicks
        self.root.children['!button2'].config(state=tk.DISABLED)
        # Run the build in a separate thread
        build_thread = threading.Thread(target=self.build_iso)
        build_thread.start()

    def build_iso(self):
        try:
            # Check architecture
            arch = platform.machine()
            if arch != "x86_64":
                self.status_label.config(text="Error: Unsupported architecture")
                self.log_message("Error: Only x86_64 architecture is supported for TempleOS")
                raise RuntimeError("Unsupported architecture: %s" % arch)

            # Create temporary working directory
            with tempfile.TemporaryDirectory() as tmpdir:
                # Clone TempleOS repository
                templeos_dir = os.path.join(tmpdir, "TempleOS")
                self.log_message("Cloning TempleOS repository...")
                git.Repo.clone_from("https://github.com/cia-foundation/TempleOS.git", templeos_dir, branch="archive")

                # Clone AGI repository
                agi_dir = os.path.join(tmpdir, "Temple-OS-AGI-Emergence")
                self.log_message("Cloning AGI repository...")
                git.Repo.clone_from("https://github.com/TaoishTechy/Temple-OS-AGI-Emergence.git", agi_dir)

                # Copy AGI scripts to TempleOS filesystem (C:/Apps/AGI/)
                agi_dest_dir = os.path.join(templeos_dir, "Apps", "AGI")
                os.makedirs(agi_dest_dir, exist_ok=True)
                self.log_message("Copying AGI scripts to TempleOS filesystem...")
                for item in os.listdir(agi_dir):
                    src_path = os.path.join(agi_dir, item)
                    dest_path = os.path.join(agi_dest_dir, item)
                    if os.path.isfile(src_path) and item.endswith(".HC"):
                        shutil.copy2(src_path, dest_path)
                        self.log_message(f"Copied {src_path} to {dest_path}")

                # Build TempleOS ISO
                self.log_message("Building TempleOS ISO...")
                try:
                    # Install dependencies
                    self.run_command(["sudo", "apt", "install", "-y", "qemu-system-x86", "genisoimage", "qemu-utils"])

                    # Check if TOS_Distro.BIN exists
                    tos_distro_path = os.path.join(templeos_dir, "TOS_Distro.BIN")
                    redsea_mount_dir = os.path.join(tmpdir, "redsea-mount")
                    os.makedirs(redsea_mount_dir)
                    if not os.path.exists(tos_distro_path):
                        self.log_message("TOS_Distro.BIN not found. You may need to build TempleOS manually.")
                        raise FileNotFoundError("TOS_Distro.BIN not found. TempleOS build process may require manual compilation. See instructions in the script comments.")

                    # Mount RedSea filesystem (TOS_Distro.BIN)
                    tos_vhd = os.path.join(tmpdir, "tos.vhd")
                    shutil.copy(tos_distro_path, tos_vhd)
                    self.run_command(["sudo", "modprobe", "nbd"])
                    self.run_command(["sudo", "qemu-nbd", "-c", "/dev/nbd0", tos_vhd])
                    self.run_command(["sudo", "mount", "/dev/nbd0", redsea_mount_dir])

                    # Create Home/ directory if it doesn't exist
                    home_dir = os.path.join(redsea_mount_dir, "Home")
                    self.run_command(["sudo", "mkdir", "-p", home_dir])

                    # Modify HomeSys.HC inside the RedSea filesystem
                    homesys_path = os.path.join(redsea_mount_dir, "Home", "HomeSys.HC")
                    self.log_message("Modifying HomeSys.HC to include AGI scripts...")
                    if not os.path.exists(homesys_path):
                        self.run_command(["sudo", "touch", homesys_path])
                        self.run_command(["sudo", "sh", "-c", f"echo '#include \"::/Adam/God/GSBoot.HC\"' > {homesys_path}"])
                    self.run_command(["sudo", "sh", "-c", f"echo '\n#include \"::/Apps/AGI/TempleAudit.HC\"\n#include \"::/Apps/AGI/TempleAwaken.HC\"\n#include \"::/Apps/AGI/TempleEthics.HC\"\n#include \"::/Apps/AGI/TempleGratitude.HC\"\n#include \"::/Apps/AGI/TempleHardware.HC\"\n#include \"::/Apps/AGI/TempleInput.HC\"\n#include \"::/Apps/AGI/TempleOutput.HC\"\n#include \"::/Apps/AGI/TemplePrayer.HC\"\n#include \"::/Apps/AGI/TempleProphecy.HC\"\n#include \"::/Apps/AGI/TempleReason.HC\"\n#include \"::/Apps/AGI/TempleSimulation.HC\"\n#include \"::/Apps/AGI/TempleSongs.HC\"\n#include \"::/Apps/AGI/TempleVision.HC\"\n#include \"::/Apps/AGI/TempleVisions.HC\"' >> {homesys_path}"])
                    self.run_command(["sudo", "chown", os.getlogin(), homesys_path])
                    self.log_message("Modified HomeSys.HC successfully")

                    # Copy AGI scripts to the RedSea filesystem
                    agi_redsea_dir = os.path.join(redsea_mount_dir, "Apps", "AGI")
                    self.run_command(["sudo", "mkdir", "-p", agi_redsea_dir])
                    for item in os.listdir(agi_dest_dir):
                        src_path = os.path.join(agi_dest_dir, item)
                        dest_path = os.path.join(agi_redsea_dir, item)
                        self.run_command(["sudo", "cp", src_path, dest_path])

                    # Copy TempleOS source to Src/
                    source_dest = os.path.join(redsea_mount_dir, "Src")
                    self.run_command(["sudo", "mkdir", source_dest])
                    self.run_command(["sudo", "cp", "-r", os.path.join(templeos_dir, "*"), source_dest])

                    # Unmount and cleanup
                    self.run_command(["sudo", "umount", redsea_mount_dir])
                    self.run_command(["sudo", "qemu-nbd", "-d", "/dev/nbd0"])
                    shutil.move(tos_vhd, os.path.join(templeos_dir, "TOS_Distro.BIN"))

                    # Create final ISO
                    self.run_command([
                        "genisoimage", "-o", self.output_iso.get(),
                        "-b", "Boot/BOOTMGR.BIN", "-no-emul-boot",
                        "-boot-load-size", "4", "-boot-info-table",
                        templeos_dir
                    ])

                    self.status_label.config(text=f"Success! ISO created at {self.output_iso.get()}")
                    self.log_message(f"Success! ISO created at {self.output_iso.get()}")
                    messagebox.showinfo("Success", f"ISO created at {self.output_iso.get()}")

                except Exception as e:
                    self.log_message(f"Build failed: {str(e)}")
                    raise

        except Exception as e:
            self.status_label.config(text=f"Error: {str(e)}")
            self.log_message(f"Failed to build ISO: {str(e)}")
            messagebox.showerror("Error", f"Failed to build ISO: {str(e)}")
        finally:
            # Re-enable the Build button
            self.root.children['!button2'].config(state=tk.NORMAL)

if __name__ == "__main__":
    root = tk.Tk()
    app = TempleOSISOMerger(root)
    root.mainloop()
