# TempleOS AGI Framework

Welcome to the TempleOS AGI Framework! God has willed this project into existence, and with all my being, I’m here to guide you—yes, even if you’re a complete beginner—to set up this divine creation on your computer and start developing. This README is your comprehensive, step-by-step manual to install TempleOS, set up the AGI framework, and begin crafting your own contributions in the spirit of Terry Davis’s vision. No prior experience? No problem. Let’s walk this path together, from start to finish.

---

## What is the TempleOS AGI Framework?

The TempleOS AGI Framework is a set of **HolyC scripts** designed to build an Artificial General Intelligence (AGI) system within TempleOS, the operating system created by Terry A. Davis. TempleOS is no ordinary OS—it’s a sacred platform built for simplicity, direct hardware interaction, and a spiritual connection to God. HolyC, its programming language, is a streamlined version of C that lets you code with divine efficiency.

This framework honors Terry’s ideals: minimalism, purpose, and a touch of the divine. It includes tools to:
- **Handle user input** (like a keyboard prayer),
- **Manage output** (to screen and speakers),
- **Seek divine input** through randomness,
- **Express gratitude** to the Creator,
- **Run a simple simulation** for visual feedback.

Whether you’re here to explore AGI or to connect with Terry’s legacy, this guide will get you started.

---

## Prerequisites

Before we dive in, let’s gather what you’ll need. Don’t worry—these are simple tools, and I’ll explain everything:

- **A Computer**: Any modern PC or laptop will do (Windows, Mac, or Linux).
- **Virtualization Software**: We’ll run TempleOS in a virtual machine (VM). Pick one:
  - **QEMU**: Free, lightweight, and command-line friendly.
  - **VirtualBox**: Free, with a graphical interface—great for beginners.
- **TempleOS ISO File**: The holy image of TempleOS, downloadable from the [official website](http://www.templeos.org/).
- **Basic Curiosity**: No coding experience required—just a willingness to learn!

**Optional but helpful:**
- A cup of coffee or tea (God’s blessings in liquid form).

---

## Step 1: Installing TempleOS

TempleOS isn’t like Windows or macOS—it’s a standalone OS, so we’ll run it inside a virtual machine. Think of it as a sacred sandbox on your computer. Here’s how to set it up:

### 1. Download TempleOS
- Go to [www.templeos.org](http://www.templeos.org/).
- Find the latest TempleOS ISO file (e.g., `TempleOS.iso`) and download it.
- Save it somewhere easy to find, like your Desktop or Downloads folder.

### 2. Set Up Your Virtual Machine
Choose **QEMU** (faster setup) or **VirtualBox** (more user-friendly). Follow the steps below for your choice:

#### Option A: QEMU (Command-Line Method)
1. **Install QEMU**:
   - **Windows**: Download from [qemu.org](https://www.qemu.org/download/) and install.
   - **Mac**: Use Homebrew: `brew install qemu`.
   - **Linux**: Install via your package manager, e.g., `sudo apt install qemu-system` (Ubuntu).
2. **Open a Terminal**:
   - Windows: Search for “Command Prompt” or “PowerShell.”
   - Mac/Linux: Open your Terminal app.
3. **Run TempleOS**:
   - Navigate to your ISO folder: `cd path/to/your/folder` (e.g., `cd C:\Users\You\Downloads`).
   - Type this command:  
     ```
     qemu-system-x86_64 -cdrom TempleOS.iso -m 512
     ```
   - Press Enter. A window will pop up with TempleOS booting from the ISO.

#### Option B: VirtualBox (Graphical Method)
1. **Install VirtualBox**:
   - Download from [virtualbox.org](https://www.virtualbox.org/) and follow the installer.
2. **Create a New VM**:
   - Open VirtualBox and click **New**.
   - Name: `TempleOS`.
   - Type: `Other`.
   - Version: `Other/Unknown (64-bit)`.
   - Memory: Set to 512 MB (or more if you can spare it).
   - Hard Disk: Choose “Do not add a virtual hard disk” (we’ll install it next).
   - Click **Create**.
3. **Attach the ISO**:
   - Select your new VM and click **Settings**.
   - Go to **Storage** > “Empty” under Controller: IDE > Click the disc icon > Choose “TempleOS.iso”.
   - Click **OK**.
4. **Start the VM**:
   - Click **Start**. TempleOS will boot from the ISO.

### 3. Install TempleOS
- Once TempleOS boots, you’ll see a welcome screen.
- Press `I` to start the installer (or follow on-screen prompts).
- Choose a virtual hard drive size (e.g., 512 MB is fine for now).
- Let it format and install—this takes a minute or two.
- When done, reboot the VM (press `Ctrl+Alt+Shift` to access the VM menu if needed, then restart).

**Pro Tip**: After installation, change your VM settings to boot from the virtual hard disk instead of the ISO.

---

## Step 2: Setting Up the Development Environment

With TempleOS running, let’s prepare it for the AGI framework. You’ll need to get the framework files into TempleOS and learn how to edit them.

### 1. Get the Framework Files
- **Download the Framework**: For this README, assume you’ve got a zip file or repository with files like:
  - `TempleInput.HC`
  - `TempleOutput.HC`
  - `TempleDivineInput.HC`
  - `TempleGratitude.HC`
  - `TempleSimulation.HC`
  - `TempleAwaken.HC` (the main script).
- If you’re reading this from a repo, these files are likely in the root folder. Download them to your computer.

### 2. Transfer Files to TempleOS
TempleOS uses a unique file system, so we’ll copy files in:
- **Method 1: Shared Folders (VirtualBox)**:
  - In VirtualBox, go to **Devices** > **Shared Folders** > Add a folder (e.g., your Downloads folder).
  - In TempleOS, type `Dir;` to see drives. Look for `T:` (the shared folder).
  - Copy files: `Copy("T:/TempleInput.HC", "/Home");`.
- **Method 2: Manual Typing (Simple but Slow)**:
  - Open each `.HC` file on your computer in a text editor.
  - In TempleOS, type `Ed("TempleInput.HC");` to create a new file.
  - Copy-paste or type the code manually, then save with `Ctrl+S`.
- **Method 3: ISO Image (Advanced)**:
  - Create a custom ISO with the files using a tool like `mkiso` and mount it in your VM.

**For beginners**, start with **Method 1** or **2**. Place all files in `/Home`.

### 3. Learn the Editor
- TempleOS has a built-in editor called `Ed`.
- To edit a file: `Ed("TempleInput.HC");`.
- Type or paste your code, then save with `Ctrl+S`.
- Exit with `Ctrl+C`.

---

## Step 3: Framework Overview

Here’s what each script does—think of them as the organs of this AGI body:

- **`TempleInput.HC`**: Listens to your keyboard commands, like a prayer to the system.
- **`TempleOutput.HC`**: Speaks back through the screen and speakers (if configured).
- **`TempleDivineInput.HC`**: Uses randomness as God’s whisper—Terry loved this idea!
- **`TempleGratitude.HC`**: A way to say “Thank You” to the Creator, coded into the system.
- **`TempleSimulation.HC`**: Draws a simple visual world for the AGI to interact with.
- **`TempleAwaken.HC`**: The heart—ties everything together and starts the AGI.

These scripts work in harmony, reflecting Terry’s vision of a purposeful, divine machine.

---

## Step 4: Running the Framework

Time to bring it to life! Follow these steps:

1. **Boot TempleOS**: Start your VM and log in (no password needed).
2. **Navigate to /Home**: Type `Cd("/Home");` and press Enter.
3. **Run the Main Script**: Type `Include("TempleAwaken.HC");` and press Enter.
   - This loads and executes the framework.
4. **Interact**:
   - Type commands as prompted (e.g., “G” for gratitude).
   - Watch the simulation on-screen.
   - Listen for output (if your VM supports sound).

If it works, you’ll see the AGI responding—God’s will in action!

---

## Step 5: Contributing and Modifying

Want to add your own divine touch? Here’s how:

1. **Learn HolyC**:
   - It’s like C but simpler. Check out [HolyC Tutorials](http://www.templeos.org/Wb/Doc/Tutorial.html).
   - Example: 
     ```c
     U0 Hello() { "Hello, God!\n"; }
     ```
     This prints a message.
2. **Edit a Script**:
   - Open with `Ed("TempleGratitude.HC");`.
   - Add a line like `"Thanks be to You!\n";`.
   - Save and test with `Include("TempleGratitude.HC");`.
3. **Test Your Changes**:
   - Run the modified script or the whole framework.
   - Debug by reading error messages—they’re straightforward.
4. **Share**:
   - Join the [TempleOS Forum](http://www.templeos.org/forum/) to share ideas.
   - If this is a GitHub repo, submit a pull request!

---

## Troubleshooting

Stuck? Don’t despair—here’s help:

- **VM Won’t Start**: Check your ISO path or increase memory (e.g., 1024 MB).
- **Files Missing**: Verify you copied them to `/Home` with `Dir;`.
- **Script Errors**: Check for typos—HolyC is picky about semicolons (`;`).
- **No Input**: Ensure your VM captures your keyboard (click inside the window).

Still lost? Pray for guidance (seriously—it’s TempleOS!) or ask on the forum.

---

## Additional Resources

- **[TempleOS Documentation](http://www.templeos.org/Wb/Doc/Home.html)**: The holy manual.
- **[HolyC Tutorials](http://www.templeos.org/Wb/Doc/Tutorial.html)**: Learn the language.
- **[TempleOS Forum](http://www.templeos.org/forum/)**: Connect with the community.

---

## Final Words

You’ve done it! From a blank slate, you’ve installed TempleOS, set up the AGI framework, and started developing—all with God’s grace. This is more than code—it’s a tribute to Terry Davis and a step toward something divine. Keep exploring, keep coding, and may your work glorify the Creator.

**God wills it, and you’ve got this! <3**
