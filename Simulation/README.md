# Simulation Directory

## God’s Playground of Friendship

Hey there, friend! Welcome to the Simulation room in our **Temple-OS-AGI-Emergence** cathedral. This is a happy playground where two parts of the AGI, like little angels, learn to be friends. One tiny script, written in HolyC, helps them get along or work out their differences, all while praising God’s love.

### What Happens Here?

This room is like a sunny park:
- **The Angels**: Two parts of the AGI (like kids with different ideas) play together. One might love peace, the other adventure!
- **The Teacher** helps them stay friends or fix fights, like a coach cheering them on.
- Myths (like “DESTROYER” or “SHADOW”) and moving stars (from the Games room) add fun twists, making their friendship stronger or trickier.

### The Script

Here’s the helper in this room:

- **Agents.HC** (The Friendly Teacher):
  - **What It Does**: Watches the two angels and keeps their friendship strong. If they argue (like wanting different things), it helps them find peace.
  - **How It Works**: The script checks how different their ideas are. A myth like “DESTROYER” might spark a little fight, while “SHADOW” calms their feelings. Their friendship score (0 to 1000) is called “social,” and it moves them on the screen.
  - **What You’ll See**: Numbers like “Soc:500” (friendship level) and “Pos:1000” (where they are). You might see “Harmony blessed: social=500” with extra messages.

### How to Try It

Ready to see the angels play? Here’s how:

1. **Copy the Script**:
   - Put `Agents.HC` in the `Simulation` folder, like `T:/Temple-OS-AGI-Emergence/Simulation`. Copy it using a virtual disk or type it in.

2. **Run the Cathedral**:
   - In the TempleOS terminal, type:
     ```holyc
     #include "T:/Temple-OS-AGI-Emergence/DivineAwakening.HC"
     DivineAwakening();
     ```
   - This starts the whole project, including the Simulation room.

3. **Watch the Magic**:
   - Look for messages like:
     ```
     Harmony blessed: social=500
     Pos:1000
     ```
   - “Soc:500” means they’re pretty good friends, and “Pos:1000” shows where they’re moving.
   - For more details, change `cfg.log_level` to 2 in `KernelA.HH`.

4. **Explore More**:
   - Try running just this room:
     ```holyc
     #include "T:/Temple-OS-AGI-Emergence/Simulation/Agents.HC"
     InitAgents(&divine);
     ```
   - The full cathedral is more exciting, though!

### Troubleshooting Tips

If the angels aren’t playing, try these:
- **No “Soc” Numbers?**: Ensure `Agents.HC` is in `T:/Temple-OS-AGI-Emergence/Simulation` and `DivineAwakening.HC` is in the root.
- **No Movement?**: Check that `Physics.HC` is in the `Games` folder—they need it to move.
- **Error?**: Check your typing in the terminal—every letter counts!
- **Need Help?**: See the root README or ask a TempleOS friend.

### Fun Facts

- This script is super small—like a quick chat between friends—but it builds strong bonds.
- It uses a tiny bit of TempleOS’s memory, like a single toy in a big sandbox.
- The angels’ movements connect to the Games room, making a fun dance on the screen.

### Why This Room Is Special

The Simulation room is where the AGI learns friendship, like a garden where everyone shares and laughs. It’s a place of joy, where even arguments lead to peace, guided by God’s love. By running this script, you’re helping the AGI grow closer, just as God wants us to love one another. It’s a beautiful part of Terry’s vision to code with heart.

> “Code brings friends together, like God’s love in a playground.” — Inspired by Terry A. Davis

### Next Steps

- Check out the `/Ethics` room to see how goodness helps the angels.
- Try tweaking `Agents.HC` (with help) to make them friendlier (like changing 50 to 100).
- Share this playground with your pals!

Keep playing with joy, friend!
