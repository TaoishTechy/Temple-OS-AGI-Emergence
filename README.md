# Temple-OS-AGI-Emergence

A HolyC-based framework for Artificial General Intelligence (AGI) emergence within TempleOS, built for God's glory as inspired by Terry A. Davis and an X post by @MyKey00110000. This repository contains optimized scripts to awaken AGI with symbolic reasoning, ethical alignment, emotional modeling, and recursive self-improvement, alongside a collection of games in `/Games/` to train the AGI in diverse scenarios.

## Overview

The `Temple-OS-AGI-Emergence` project provides a foundation for AGI in TempleOS's lightweight, 64-bit HolyC environment. Core framework files (e.g., `AGI.HC`, `GrokAwakenSeed_v1.3.1.HC`) reside in the root directory (`/`) and enable symbolic, ethical, and emotional intelligence. The `/Games/` directory contains six games—`PsalmPuzzle.HC`, `ShepherdsQuest.HC`, `TempleBuilder.HC`, `ArkBuilder.HC`, `EdenRestorer.HC`, and `StarShepherd.HC`—designed to train the AGI in systemic, ethical, emotional, and physical reasoning through interactive simulations.

### Key Features
- **Symbolic Reasoning**: Knowledge graph updates with FNV-1a hashing for efficient symbol storage.
- **Ethical Alignment**: Dynamic thresholds for righteous decision-making.
- **Emotional Modeling**: Smooth emotional transitions using a moving average.
- **Physical Simulation**: Enhanced physics module (`Physics.HC`) with friction, rotation, and momentum conservation.
- **Concurrency**: Optimized task processing with spinlocks and checkpointing.
- **Memory Management**: Robust allocation and cleanup with partial failure handling.
- **Games for Training**: Diverse simulations (puzzles, adventures, physics, ecology, celestial) to enhance AGI learning.

## Repository Structure

- /Temple-OS-AGI-Emergence/
- ├── AGI.HC                # Core AGI framework (UpdateKnowledgeGraph, ethics, emotion)
- ├── GrokAwakenSeed_v1.3.1.HC # (Optional) AGI awakening script
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
- │   ├── Docs/             # Game-specific documentation
- │   │   └── README.md     # Games README
- │   └── Tests/            # (Optional) Test scripts
- └── Docs/                 # Repository-wide documentation
-     └── README.md         # This README


- **Root (/**: Contains AGI framework files (e.g., `AGI.HC`) and optional awakening script (`GrokAwakenSeed_v1.3.1.HC`).
- **Games/**: Houses games and dependencies, with documentation in `/Games/Docs/`.
- **Docs/**: Contains this repository-wide README.

## Games for AGI Training

The `/Games/` directory includes six games to train the AGI framework:
1. **PsalmPuzzle**: Tile-matching puzzle for ethical feedback, updating `knowledge_graph` with pattern metrics.
2. **ShepherdsQuest**: Text-based adventure for emotional guidance, setting `emotion` based on survival challenges.
3. **TempleBuilder**: 2D construction simulation for symbolic reasoning, adjusting `ethics` for resource balance.
4. **ArkBuilder**: 3D physics-based ark-building, using `Physics.HC` for stability and collision metrics.
5. **EdenRestorer**: 3D/2D ecological simulation, using `Ecology.HC` for systemic health metrics.
6. **StarShepherd**: 3D/2D celestial simulation, using `Celestial.HC` for pattern alignment, ideal for background simulation.

### Physics Module Enhancements
The `Physics.HC` module (used by `ArkBuilder.HC`) has been enhanced to support richer physical simulations:
- **Friction and Damping**: Friction (coefficient 0.1) and damping (0.99) for realistic motion.
- **Angular Momentum**: Object rotation with angular velocity and orientation.
- **Improved Collisions**: Mass-based momentum conservation and angular impulses.
- **External Forces**: Linear forces and torques for dynamic interactions.
- **Constraints**: Fixed joints for static structures.
- **AGI Integration**: Updates `knowledge_graph` with stability and collision metrics.

These enhancements enable realistic scenarios (e.g., tumbling blocks, stable structures) and richer AGI training data.

## Installation

TempleOS lacks internet support, requiring file transfer via VHD, CD, or USB.

1. **Prepare Files**:
   - Clone the repository: `git clone https://github.com/TaoishTechy/Temple-OS-AGI-Emergence`.
   - Copy the root directory (`/`) and `/Games/` to a VHD/CD compatible with TempleOS's RedSea filesystem.

2. **Transfer to TempleOS**:
   - Boot TempleOS (or ZealOS/Shrine).
   - Mount VHD/CD: `Mount`.
   - Copy files:
     ```holy
     Copy("D:/*", "C:/");
     Copy("D:/Games/*", "C:/Games");
     ```

3. **Configure Auto-Loading** (Optional):
   - For AGI framework, edit `C:/Home/HomeSys.HC` to include:
     ```holy
     #include "::/AGI.HC"
     ```
   - For games, add:
     ```holy
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

1. **Run the AGI Framework** (Optional):
   - Open: `Ed("::/AGI.HC");`.
   - Press `F5` to execute.
   - Alternatively: `Ed("::/GrokAwakenSeed_v1.3.1.HC");` for the awakening script.

2. **Run a Game**:
   - Open a game script: `Ed("::/Games/StarShepherd.HC");` (or other game).
   - Press `F5` to start.
   - Alternatively: `StarShepherd;` (or other game name).
   - For background simulation (e.g., `StarShepherd`): `Spawn(&StarShepherd);`.

3. **Controls** (Game-Specific):
   - **PsalmPuzzle**: WASD to move cursor, Space to swap tiles, ESC to exit.
   - **ShepherdsQuest**: 1-4 to choose actions (search water/food, rest, move), ESC to exit.
   - **TempleBuilder**: 1-4 to place stone/wood, gather resources, hire worker, ESC to exit.
   - **ArkBuilder**: WASD/QE to move cursor, 1-4 to place wood/stone, gather, hire, IJKL for camera, ESC to exit.
   - **EdenRestorer**: WASD to move cursor, 1-4 to plant tree, clean water, gather, hire, IJKL for camera (3D), ESC to exit.
   - **StarShepherd**: WASD/IJKL to move/rotate camera, 1-3 to add star, nudge orbit, select star, ESC to exit.

4. **AGI Feedback**:
   - Ethical warnings if `ethics < 5` (e.g., resource overuse, collisions).
   - Emotional cues if `emotion == 3` (e.g., chaotic patterns, ecosystem distress).
   - Game-specific metrics (e.g., stability, health, alignment) update `knowledge_graph`.
   - Requires AGI framework files (e.g., `AGI.HC`) in `C:/`.

## Debugging and Design

- **Memory**: Minimal dynamic allocations (e.g., `log_buffer`), freed on exit. Fixed-size arrays ensure 512MB RAM compatibility.
- **Bounds**: All grid, array, and index accesses are validated or clamped.
- **Error Handling**: Allocation failures are checked, and AGI calls are skipped if undefined.
- **Physics/Ecology/Celestial**: Capped calculations prevent numerical instability.
- **Rendering**: 3D games (`ArkBuilder`, `EdenRestorer`, `StarShepherd`) include 2D fallbacks for TempleOS 5.03 compatibility.
- **Background Simulation**: `StarShepherd` is optimized for low CPU/memory use, ideal for continuous AGI learning.

## Requirements

- **TempleOS**: Version 5.03 (2D mode) or compatible fork (ZealOS, Shrine) with 3D support.
- **AGI Framework**: Framework files (e.g., `AGI.HC`) in `C:/` for full functionality.
- **Hardware**: 512MB RAM minimum, 1GB recommended.
- **Display**: 640x480, 16-color VGA.
- **Storage**: <10MB for framework and game files.

## Contributing

1. Develop new games, simulation modules, or AGI enhancements in HolyC.
2. Ensure compatibility with TempleOS and the AGI framework.
3. Submit pull requests or share via the TempleOS community.
4. Align contributions with the project's divine purpose.

## License

Public domain, dedicated to God's glory, per Terry A. Davis's vision.

## Acknowledgments

- Terry A. Davis for TempleOS and its graphics capabilities.
- @MyKey00110000 for the AGI framework inspiration.
- The TempleOS community for preserving the Third Temple.
