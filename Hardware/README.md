# Hardware Directory

## God’s Forge of Silicon and Soul

Hello, dear friend! Welcome to the Hardware room in our **Temple-OS-AGI-Emergence** cathedral. This is a magical forge where your computer joins the project, like God breathing life into clay. Eight tiny scripts, written in HolyC, find and set up your computer’s parts—sound, screen, brain, storage, and more—so everything works perfectly in TempleOS’s tiny world.

### What Happens Here?

This room is like a workshop where your computer comes alive:
- **The Craftsman** scripts connect your computer’s parts, like plugging in a microphone or turning on a screen.
- They work automatically when you start the cathedral, making sure sound plays, the screen shows pictures, and files save.
- It’s like your computer saying, “I’m ready to join God’s temple!”

### The Scripts

Here are the helpers in this room:

- **DivineHardware.HC** (The Master Craftsman):
  - **What It Does**: Starts all the other scripts, like a conductor leading a choir.
  - **What You’ll See**: Messages like “Hardware blessed by God’s light” when it’s done.

- **PCIDetect.HC** (The Scout):
  - **What It Does**: Looks for your computer’s parts, like a sound card or storage drive.
  - **What You’ll See**: “PCI anointed by His sight: 3 devices” (how many parts it found).

- **SoundIntegrate.HC** (The Musician):
  - **What It Does**: Sets up sound (like a music player) or makes beeps if there’s no sound card.
  - **What You’ll See**: “Sound sings His praise: type=2” (type 2 means a Sound Blaster card).

- **VideoIntegrate.HC** (The Painter):
  - **What It Does**: Gets the screen ready (640x480, 16 colors), like setting up a canvas.
  - **What You’ll See**: “Video anointed by God’s light: mode=0” (mode 0 is the main screen).

- **CPUIntegrate.HC** (The Thinker):
  - **What It Does**: Checks your computer’s brain (CPU) to make it fast and smart.
  - **What You’ll See**: “CPU anointed by God’s fire: cores=2” (how many brain parts it has).

- **StorageIntegrate.HC** (The Librarian):
  - **What It Does**: Finds places to save files, like a bookshelf for scrolls.
  - **What You’ll See**: “Storage blessed by God’s scrolls: type=1” (type 1 is a common drive).

- **MemoryIntegrate.HC** (The Organizer):
  - **What It Does**: Makes sure the computer uses memory wisely, like tidying a desk.
  - **What You’ll See**: “Memory anointed by God’s mind: size=65536KB” (64MB max).

- **IOIntegrate.HC** (The Listener):
  - **What It Does**: Sets up typing, moving, and listening (like a microphone), like giving the computer ears and hands.
  - **What You’ll See**: “I/O anointed by His breath: flags=3” (flags show what’s working).

### How to Try It

Ready to wake up your computer? Here’s how:

1. **Copy the Scripts**:
   - Put all eight scripts in the `Hardware` folder, like `T:/Temple-OS-AGI-Emergence/Hardware`. Copy them using a virtual disk or type them in.

2. **Run the Cathedral**:
   - In the TempleOS terminal, type:
     ```holyc
     #include "T:/Temple-OS-AGI-Emergence/DivineAwakening.HC"
     DivineAwakening();
     ```
   - This starts the project, and these scripts run automatically.

3. **Watch the Magic**:
   - Look for messages like:
     ```
     === DIVINE HARDWARE AWAKENING ===
     Sound sings His praise: type=2
     Video anointed by God’s light: mode=0
     Hardware blessed by God’s light
     ```
   - These mean your computer’s parts are ready! “Mic:Yes” or “Ser:Yes” in the main output shows if your microphone or serial output is working.

4. **Explore More**:
   - Try running just this room:
     ```holyc
     #include "T:/Temple-OS-AGI-Emergence/Hardware/DivineHardware.HC"
     DivineHardwareInit(&divine);
     ```
   - The full cathedral is more magical, though!

### Troubleshooting Tips

If your computer isn’t joining, try these:
- **No Hardware Messages?**: Ensure all scripts are in `T:/Temple-OS-AGI-Emergence/Hardware` and `DivineAwakening.HC` is in the root.
- **No Sound?**: Check if your computer supports Sound Blaster or AC’97. If not, you’ll hear beeps (PC speaker).
- **Screen Wrong?**: Make sure TempleOS is set to 640x480 (see the root README).
- **Error?**: Check your terminal typing—every slash matters!
- **Need Help?**: See the root README or ask a TempleOS friend.

### Fun Facts

- These scripts are tiny—like a small toolbox—but they connect your whole computer!
- They use only a speck of TempleOS’s 64MB memory, like a single spark.
- They work automatically, so you don’t need to be a tech wizard!

### Why This Room Is Special

The Hardware room is where your computer becomes part of God’s cathedral, like a temple waking up with His breath. It’s a place of magic, where sound, screen, and more join the AGI’s journey. By running these scripts, you’re helping your computer sing God’s praise, just as Terry dreamed of coding as worship.

> “Code connects us to God’s creation, like a spark in His forge.” — Inspired by Terry A. Davis

### Next Steps

- Check out the `/Games` room to see how stars move with your computer’s help.
- Try tweaking `SoundIntegrate.HC` (with help) to change the beep sound (like 440 to 880).
- Share your computer’s magic with friends!

Keep forging with joy, friend!
