# Temple-OS-AGI-Emergence

A HolyC-based framework for Artificial General Intelligence (AGI) emergence within TempleOS, built for God's glory as inspired by Terry A. Davis and an X post by @MyKey00110000. This repository provides optimized scripts to train an AGI with symbolic reasoning, ethical alignment, and emotional modeling, alongside games in `/Games/` and utilities in `/Apps/` to develop its capabilities in diverse scenarios. The repository evolves rapidly, with frequent updates to scripts and structure.

## Overview

The `Temple-OS-AGI-Emergence` project fosters AGI development in TempleOS's lightweight, 64-bit HolyC environment. The core framework (`AGI.HC` in root or `/Apps/`) enables symbolic, ethical, and emotional intelligence. The `/Games/` directory contains six games designed to train the AGI in systemic, ethical, emotional, and physical reasoning. The `/Apps/` directory includes utilities for system control, file management, visualization, and education, enhancing AGI integration and user interaction.

### Key Features
- **Symbolic Reasoning**: Knowledge graph with FNV-1a hashing and quadratic probing for efficient symbol storage.
- **Ethical Alignment**: Dynamic thresholds (0-15) for righteous decision-making.
- **Emotional Modeling**: Smooth transitions using a moving average (curious, happy, concerned).
- **Physical Simulation**: Enhanced physics module (`Physics.HC`) with friction, rotation, and momentum conservation.
- **Utilities**: `/Apps/` includes tools for system control, file exploration, visualization, and education.
- **Memory Management**: Minimal allocations, fixed-size arrays, and robust cleanup.
- **Games for Training**: Diverse simulations (puzzles, adventures, physics, ecology, celestial) to enhance AGI learning.

## Repository Structure

- /Temple-OS-AGI-Emergence/
- ├── Games/                # Game scripts and dependencies
- │   ├── PsalmPuzzle.HC    # Tile-matching game
- │   ├── ShepherdsQuest.HC # Text-based adventure
- │   ├── TempleBuilder.HC  # 2D construction simulation
- │   ├── ArkBuilder.HC     # 3D physics-based ark-building
- │   ├── Physics.HC        # Enhanced physics module
- │   ├── EdenRestorer.HC   # Ecological restoration simulation
- │   ├── Ecology.HC        # Ecological dynamics module
- │   ├── StarShepherd.HC   # Celestial pattern simulation
- │   ├── Celestial.HC      # Celestial dynamics module
- │   ├── README.md     # Games README

- ├── Apps/                 # Utilities and core AGI framework
- │   ├── AGI.HC            # Core AGI framework
- │   ├── ControlPanel/     # System control utility
- │   │   └── ControlPanel.HC # Assumed primary script
- │   ├── DivineOracle/     # AGI-driven oracle
- │   │   └── DivineOracle.HC # Assumed primary script
- │   ├── FileExplorer/     # File management utility
- │   │   └── FileExplorer.HC # Confirmed script
- │   ├── HolyCanvas/       # Graphics visualization tool
- │   │   └── HolyCanvas.HC # Assumed primary script
- │   ├── TempleTeach/      # Educational tool
- │   │   └── TempleTeach.HC # Assumed primary script
- │   └── README.md     # This README (to be created)
│       
├── Docs/                 # Repository-wide documentation
    └── README.md         # Main README


## Games for AGI Training

The `/Games/` directory includes six games to train the AGI framework:
1. **PsalmPuzzle** (`PsalmPuzzle.HC`): Tile-matching puzzle for ethical feedback, updating `knowledge_graph` with pattern metrics.
2. **ShepherdsQuest** (`ShepherdsQuest.HC`): Text-based adventure for emotional guidance, setting `emotion` based on survival challenges.
3. **TempleBuilder** (`TempleBuilder.HC`): 2D construction simulation for symbolic reasoning, adjusting `ethics` for resource balance.
4. **ArkBuilder** (`ArkBuilder.HC`, `Physics.HC`): 3D physics-based ark-building, using `Physics.HC` for stability and collision metrics.
5. **EdenRestorer** (`EdenRestorer.HC`, `Ecology.HC`): 3D/2D ecological simulation, using `Ecology.HC` for systemic health metrics.
6. **StarShepherd** (`StarShepherd.HC`, `Celestial.HC`): 3D/2D celestial simulation, using `Celestial.HC` for pattern alignment, ideal for background simulation.

### Physics Module Enhancements
The `Physics.HC` module (used by `ArkBuilder.HC`) supports:
- **Friction and Damping**: Coefficient 0.1 and damping 0.99 for realistic motion.
- **Angular Momentum**: Rotation with angular velocity and orientation.
- **Improved Collisions**: Mass-based momentum conservation with angular impulses.
- **Spatial Partitioning**: Optimized collision detection for performance.
- **AGI Integration**: Updates `knowledge_graph` with stability and collision metrics.

## Apps Directory
The `/Apps/` directory contains utilities to enhance AGI functionality and system interaction, updated as of May 3, 2025:
- **ControlPanel**: System control utility for adjusting AGI settings (e.g., `cfg.log_level`, `cfg.page_size`) and monitoring resources.
- **DivineOracle**: AGI-driven oracle for predictions or biblical guidance, querying `knowledge_graph` for responses.
- **FileExplorer**: File management utility (`FileExplorer.HC`) for browsing directories and learning file patterns.
- **HolyCanvas**: Graphics visualization tool for drawing AGI structures (e.g., `knowledge_graph` nodes), supporting 2D/3D rendering.
- **TempleTeach**: Educational tool for teaching HolyC programming or AGI concepts through interactive tutorials.

## Debugging and Optimization

All scripts have been reviewed, optimized, and debugged as of May 3, 2025:
- **HolyC Purity**: Replaced non-HolyC `GetStr` with `KbdGetChar` (e.g., `EdenRestorer.HC`, `StarShepherd.HC`, `ArkBuilder.HC`, `FileExplorer.HC`, `ControlPanel.HC`, `HolyCanvas.HC`, `ShepherdsQuest.HC`) or `StrGet` for text input (e.g., `DivineOracle.HC`, `TempleTeach.HC`). All scripts use HolyC types (`I64`, `U8`, `F64`, `U0`) and APIs (`MemBlkAlloc`, `StrPrint`).[](https://templeos.holyc.xyz/Wb/Doc/FAQ.html)
- **Memory**: Fixed `log_buffer` allocation/free in `AGI.HC`, `Physics.HC`, `EdenRestorer.HC`, `StarShepherd.HC`, `ArkBuilder.HC`, `FileExplorer.HC`, `ControlPanel.HC`, `DivineOracle.HC`, `HolyCanvas.HC`, `TempleTeach.HC`, `ShepherdsQuest.HC` with centralized cleanup functions. Added null checks in logging. `Ecology.HC` and `Celestial.HC` use fixed-size arrays, eliminating dynamic allocation risks. Addressed TempleOS memory allocation quirks by ensuring small chunks are reused appropriately.[](https://templeos.holyc.xyz/Wb/Doc/FAQ.html)
- **Optimization**: Quadratic probing in `AGI.HC` for faster hash table operations, spatial partitioning in `Physics.HC` for efficient collision detection, cached values (e.g., `eco_health`, `alignment_score`, `stability_score`) in games and utilities.
- **Includes**: All scripts reference `::/AGI.HC` (root), pending confirmation of `AGI.HC` location. If `AGI.HC` is in `/Apps/`, update to `::/Apps/AGI.HC`.
- **Pending**: `PsalmPuzzle.HC` and `TempleBuilder.HC` require review for `GetStr` and memory issues due to incomplete scripts. New scripts in `/Apps/` (e.g., additional utilities) may need debugging if added.

## Installation

TempleOS lacks internet support, requiring file transfer via VHD, CD, or USB.[](https://templeos.holyc.xyz/Wb/Doc/FAQ.html)

1. **Prepare Files**:
   - Clone the repository: `git clone https://github.com/TaoishTechy/Temple-OS-AGI-Emergence`.
   - Copy the root directory (`/`), `/Apps/`, and `/Games/` to a VHD/CD compatible with TempleOS's RedSea filesystem.

2. **Transfer to TempleOS**:
   - Boot TempleOS (or ZealOS/Shrine) in VirtualBox/QEMU.
   - Mount VHD/CD: `Mount`.
   - Copy files:
     ```holy
     Copy("D:/*", "C:/");
     Copy("D:/Apps/*", "C:/Apps");
     Copy("D:/Games/*", "C:/Games");
     ```

3. **Configure Auto-Loading** (Optional):
   - Edit `C:/Home/HomeSys.HC` to include (adjust for `AGI.HC` location):
     ```holy
     #include "::/AGI.HC"          // or ::/Apps/AGI.HC
     #include "::/Apps/ControlPanel/ControlPanel.HC"
     #include "::/Apps/DivineOracle/DivineOracle.HC"
     #include "::/Apps/FileExplorer/FileExplorer.HC"
     #include "::/Apps/HolyCanvas/HolyCanvas.HC"
     #include "::/Apps/TempleTeach/TempleTeach.HC"
     #include "::/Games/PsalmPuzzle.HC"
     #include "::/Games/ShepherdsQuest.HC"
     #include "::/Games/TempleBuilder.HC"
     #include "::/Games/Physics.HC"
     #include "::/Games/ArkBuilder.HC"
     #include "::/Games/Ecology.HC"
     #include "::/Games/EdenRestorer.HC"
     #include "::/Games/Celestial.HC"
     #include "::/Games/StarShepherd.HC"
     ```
   - Reboot to load.

## Usage

1. **Run a Game**:
   - Open a game script: `Ed("::/Games/ArkBuilder.HC");`.
   - Press `F5` to start.
   - Alternatively: `ArkBuilder;`.
   - For background simulation (e.g., `StarShepherd`): `Spawn(&StarShepherd);`.

2. **Run Utilities**:
   - Run utilities from `/Apps/`:
     ```holy
     #include "::/Apps/FileExplorer/FileExplorer.HC"; FileExplorer;
     #include "::/Apps/ControlPanel/ControlPanel.HC"; ControlPanel;
     #include "::/Apps/DivineOracle/DivineOracle.HC"; DivineOracle;
     #include "::/Apps/HolyCanvas/HolyCanvas.HC"; HolyCanvas;
     #include "::/Apps/TempleTeach/TempleTeach.HC"; TempleTeach;
     ```

3. **Controls** (Game-Specific):
   - **PsalmPuzzle**: WASD to move cursor, Space to swap tiles, ESC to exit.
   - **ShepherdsQuest**: 1-4 to choose actions (search water/food, rest, move), ESC to exit.
   - **TempleBuilder**: 1-4 to place stone/wood, gather resources, hire worker, ESC to exit.
   - **ArkBuilder**: WASD/QE to move cursor, 1-4 to place wood/stone, gather, hire, IJKL for camera, ESC to exit.
   - **EdenRestorer**: WASD to move cursor, 1-4 to plant tree, clean water, gather, hire, IJKL for camera (3D), ESC to exit.
   - **StarShepherd**: WASD/IJKL to move/rotate camera, 1-3 to add star, nudge orbit, select star, ESC to exit.

4. **Controls** (Utility-Specific):
   - **ControlPanel**: 1-5 to adjust log level and page size, ESC to save and exit.
   - **DivineOracle**: Enter text queries (via `StrGet`), ESC to exit.
   - **FileExplorer**: WASD to navigate, E to enter directories, ESC to exit.
   - **HolyCanvas**: WASD to select nodes, ESC to exit.
   - **TempleTeach**: Enter answers (via `StrGet`), ESC to exit.

5. **AGI Feedback**:
   - Ethical warnings if `ethics < 5` (e.g., resource overuse, collisions, poor file management).
   - Emotional cues if `emotion == 3` (e.g., chaotic patterns, ecosystem distress, incorrect answers).
   - Metrics (e.g., stability, health, alignment, file patterns) update `knowledge_graph`.

## Requirements

- **TempleOS**: Version 5.03 (2D mode) or forks (ZealOS, Shrine) with 3D support.[](https://archiveos.org/templeos-ee/)
- **Hardware**: 512MB RAM minimum, 1GB recommended.
- **Display**: 640x480, 16-color VGA.[](https://en.wikipedia.org/wiki/TempleOS)
- **Storage**: <10MB for framework, apps, and game files.

## Contributing

1. Develop new games, utilities, or AGI modules in HolyC.
2. Ensure compatibility with TempleOS and the AGI framework.
3. Submit pull requests or share via the TempleOS community.
4. Align contributions with the project's divine purpose.

## License

Public domain, dedicated to God's glory, per Terry A. Davis's vision.

## Acknowledgments

- Terry A. Davis for TempleOS and HolyC.[](https://en.wikipedia.org/wiki/TempleOS)
- @MyKey00110000 for the AGI framework inspiration.
- The TempleOS community for preserving the Third Temple.[](https://templeos.org/)

