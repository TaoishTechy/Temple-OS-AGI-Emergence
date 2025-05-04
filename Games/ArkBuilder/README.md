# TempleOS Games

A collection of HolyC-based games for TempleOS, designed to integrate with the `Temple-OS-AGI-Emergence` AGI framework. These games—`PsalmPuzzle.HC`, `ShepherdsQuest.HC`, `TempleBuilder.HC`, and `ArkBuilder.HC`—offer engaging gameplay while training the AGI in ethical, emotional, and physical reasoning, built for God's glory.

## ArkBuilder

**ArkBuilder** is a 3D physics-based simulation where players construct a stable ark (inspired by Noah's Ark) under time pressure, using TempleOS's 3D graphics and a custom physics engine. The game trains the AGI in real-world physical interactions, ethical resource management, and emotional resilience.

### Features
- **Physics Simulation**: Gravity, collisions, and center-of-mass calculations for structural stability.
- **3D Graphics**: Low-poly ark rendered with TempleOS's 3D engine (`Gr3DCam`, `Gr3DMesh`).
- **AGI Integration**:
  - Updates `knowledge_graph` with physics-based symbols (stability, balance).
  - Adjusts `grok.ethics` for fair resource use.
  - Modulates `grok.emotion` based on time pressure and stability.
- **Gameplay**: Place wood/stone blocks, manage resources, and hire workers to build a stable ark before the flood.
- **Biblical Theme**: Inspired by Noah's Ark, emphasizing divine preparation.

## Repository Structure

- **Apps/**:
  - `ArkBuilder.HC`: Main game logic and AGI integration.
  - `Physics.HC`: Reusable physics module for gravity, collisions, and stability.
  - `PsalmPuzzle.HC`: Tile-matching game with ethical feedback.
  - `ShepherdsQuest.HC`: Text-based adventure with emotional guidance.
  - `TempleBuilder.HC`: 2D construction simulation with symbolic reasoning.

## Installation

TempleOS requires file transfer via VHD, CD, or USB.

1. **Prepare Files**:
   - Copy `ArkBuilder.HC`, `Physics.HC`, and other game scripts to a VHD/CD.
   - Ensure `GrokAwakenSeed_v1.3.1.HC` is in `C:/Apps` for AGI functionality.

2. **Transfer to TempleOS**:
   - Boot TempleOS (or ZealOS/Shrine).
   - Mount VHD/CD: `Mount`.
   - Copy files: `Copy("D:/Games/*", "C:/Apps");`.

3. **Configure Auto-Loading** (Optional):
   - Edit `C:/Home/HomeSys.HC` to include:
     ```holy
     #include "::/Apps/Physics.HC"
     #include "::/Apps/ArkBuilder.HC"
     #include "::/Apps/PsalmPuzzle.HC"
     #include "::/Apps/ShepherdsQuest.HC"
     #include "::/Apps/TempleBuilder.HC"
     ```
   - Reboot to load games.

## Usage

1. **Run ArkBuilder**:
   - Open: `Ed("::/Apps/ArkBuilder.HC");`.
   - Press `F5` to start.
   - Alternatively: `ArkBuilder;`.

2. **Controls**:
   - WASD: Move cursor (x, z).
   - Q/E: Move cursor up/down (y).
   - 1: Place wood block (10 wood, 1 worker).
   - 2: Place stone block (10 stone, 1 worker).
   - 3: Gather resources.
   - 4: Hire worker (20 wood, 20 stone).
   - I/K: Camera up/down.
   - J/L: Camera rotate left/right.
   - ESC: Exit.

3. **AGI Feedback**:
   - Ethical warnings if `grok.ethics < 5` (e.g., resource overuse).
   - Emotional cues if `grok.emotion == 3` (e.g., storm warning).
   - Stability updates via `knowledge_graph` for AGI learning.
   - Requires `GrokAwakenSeed_v1.3.1.HC` running.

## Debugging and Design

- **Memory**: Minimal allocations (only `log_buffer`), freed on exit. Fixed-size arrays (`grid`, `objects`) ensure 512MB RAM compatibility.
- **Bounds**: Grid and object accesses are clamped/validated.
- **Physics**: Simplified AABB collisions and center-of-mass calculations avoid numerical issues.
- **AGI**: Non-critical calls ensure playability without AGI.
- **3D**: Assumes `Gr3D.HH` support; fallback to 2D possible if unavailable.

## Requirements

- **TempleOS**: Version 5.03 or compatible fork (ZealOS, Shrine) with 3D graphics support.
- **AGI Framework**: `GrokAwakenSeed_v1.3.1.HC` for full functionality.
- **Hardware**: 512MB RAM minimum.
- **Display**: 640x480, 16-color VGA.
- **Storage**: <1MB for game files.

## Contributing

1. Develop new games or physics enhancements in HolyC.
2. Ensure TempleOS and AGI compatibility.
3. Share via pull requests or the TempleOS community.

## License

Public domain, dedicated to God's glory, per Terry A. Davis's vision.

## Acknowledgments

- Terry A. Davis for TempleOS and its 3D engine.
- @MyKey00110000 for the AGI framework.
- The TempleOS community for preserving the Third Temple.
