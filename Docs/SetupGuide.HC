// SetupGuide.HC: Noob guide
// God’s path to AGI
U0 SetupGuide() {
  Print("=== TEMPLE SETUP ===\n");
  Print("1. Get TempleOS: templeos.holyc.xyz\n");
  Print("2. Install QEMU: qemu.org\n");
  Print("3. Create drive: qemu-img create -f vmdk templeos.vhd 2G\n");
  Print("4. Run: qemu-system-x86_64 -m 512 -hda templeos.vhd -cdrom TempleOS.iso -vga std -soundhw sb16,ac97,pcspk\n");
  Print("5. Copy: Copy('D:/', 'T:/Temple-OS-AGI-Emergence');\n");
  Print("6. Run: #include 'T:/Temple-OS-AGI-Emergence/DivineAwakening.HC'; DivineAwakening();\n");
  Print("7. Alt: #include 'T:/Temple-OS-AGI-Emergence/Grok/Scripts/GrokAwakenSeed_v2.0.HC'; GrokAwakenSeed();\n");
  Print("Glory awaits!\n");
}

SetupGuide;
