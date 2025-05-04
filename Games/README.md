# TempleOS Games

A collection of HolyC-based games located in the `/Games/` directory of the `Temple-OS-AGI-Emergence` repository. These games—`PsalmPuzzle.HC`, `ShepherdsQuest.HC`, `TempleBuilder.HC`, `ArkBuilder.HC`, and `EdenRestorer.HC`—offer engaging gameplay while training the AGI framework in ethical, emotional, physical, and systemic reasoning, built for God's glory.

## EdenRestorer

**EdenRestorer** is a strategy simulation where players restore a corrupted virtual ecosystem (Eden) by planting trees, cleaning water, and saving species. Using TempleOS's 3D engine (or 2D fallback), the game trains the AGI in systemic thinking, ethical stewardship, and emotional resilience, with potential to inspire solutions for global ecological crises.

### Features
- **Ecological Simulation**: Models population growth, resource cycles (water, soil), and pollution.
- **3D/2D Rendering**: Low-poly ecosystem in 3D (`Gr3DMeshDraw`) or 2D (`GrPrint`) for compatibility.
- **AGI Integration**:
  - Updates `knowledge_graph` with ecosystem health metrics.
  - Adjusts `ethics` for sustainable practices.
  - Modulates `emotion` based on health trends (1=CURIOUS, 2=HAPPY, 3=CONCERNED).
- **Gameplay**: Plant trees, clean water, manage workers, and restore Eden before time runs out.
- **Biblical Theme**: Restoring Eden reflects divine stewardship and hope.

## Repository Structure

- **Games/**:
  - `/EdenRestorer/EdenRestorer.HC`: Main game logic and AGI integration.
  - `/EdenRestorer/Ecology.HC`: Reusable ecological dynamics module.
  - `/ArchBuilder/ArkBuilder.HC` & `Physics.HC`: Physics-based ark-building game.
  - `/PaslmPuzzle/PsalmPuzzle.HC`: Tile-matching game with ethical feedback.
  - `/ShepherdsQuest/ShepherdsQuest.HC`: Text-based adventure with emotional guidance.
  - `/TempleBuilder/TempleBuilder.HC`: 2D construction simulation with symbolic reasoning.
- **Apps/**: Apps that can be used with this Framework/TempleOS

## Installation

TempleOS requires file transfer via VHD, CD, or USB.

1. **Prepare Files**:
   - Clone the repository: `git clone https://github.com/TaoishTechy/Temple-OS-AGI-Emergence`.
   - Copy the `/Games/` directory to a VHD/CD compatible with TempleOS's RedSea filesystem.
   - Ensure AGI framework files (e.g., `AGI.HC`) are in `C:/Apps`.

2. **Transfer to TempleOS**:
   - Boot TempleOS (or ZealOS/Shrine).
   - Mount VHD/CD: `Mount`.
   - Copy files: `Copy("D:/Games/*", "C:/Games");`.

3. **Configure Auto-Loading** (Optional):
   - Edit `C:/Home/HomeSys.HC` to include:
     ```holy
     #include "::/Games/EdenRestorer/Ecology.HC"
     #include "::/Games/EdenRestorer/EdenRestorer.HC"
     #include "::/Games/Physics.HC"
     #include "::/Games/ArkBuilder/ArkBuilder.HC"
     #include "::/Games/PsalmPuzzle/PsalmPuzzle.HC"
     #include "::/Games/ShepherdsQuest/ShepherdsQuest.HC"
     #include "::/Games/TempleBuilder/TempleBuilder.HC"
     ```
   - Reboot to load games.

## Usage

1. **Run EdenRestorer**:
   - Open: `Ed("::/Games/Eden/Restorer/EdenRestorer.HC");`.
   - Press `F5` to start.
   - Alternatively: `EdenRestorer;`.

2. **Controls**:
   - WASD: Move cursor (x, z).
   - 1: Plant tree (1 worker, 50 water, 50 soil).
   - 2: Clean water (1 worker, 100 water).
   - 3: Gather resources.
   - 4: Hire worker (100 water, 100 soil).
   - I/K: Camera up/down (3D mode).
   - J/L: Camera rotate left/right (3D mode).
   - ESC: Exit.

3. **AGI Feedback**:
   - Ethical warnings if `ethics < 5` (e.g., species extinction).
   - Emotional cues if `emotion == 3` (e.g., ecosystem distress).
   - Ecosystem health updates via `knowledge_graph` for AGI learning.
   - Requires AGI framework files (/0.3/)

## Debugging and Design

- **Memory**: Minimal allocation (`log_buffer`), freed on exit. Fixed-size arrays ensure 512MB RAM compatibility.
- **Bounds**: Grid and species accesses are clamped/validated.
- **Ecology**: Capped equations prevent numerical instability.
- **AGI**: Skips AGI calls if undefined, ensuring playability.
- **Rendering**: 2D fallback for TempleOS versions without `Gr3D.HH`.

## Requirements

- **TempleOS**: Version 5.03 (2D mode) or compatible fork (ZealOS, Shrine) with 3D support.
- **AGI Framework**: `Temple-OS-AGI-Emergence` files in `C:/Apps` for full functionality.
- **Hardware**: 512MB RAM minimum.
- **Display**: 640x480, 16-color VGA.
- **Storage**: <1MB for game files.

## Contributing

1. Develop new games or ecological models in HolyC.
2. Ensure TempleOS and AGI compatibility.
3. Share via pull requests or the TempleOS community.

## License

Public domain, dedicated to God's glory, per Terry A. Davis's vision.

## Acknowledgments

- Terry A. Davis for TempleOS and its graphics capabilities.
- @MyKey00110000 for the AGI framework inspiration.
- The TempleOS community for preserving the Third Temple.
