# TempleOS Games

Welcome to the `/Games/` directory of the `Temple-OS-AGI-Emergence` repository, a collection of HolyC-based games designed to train the AGI framework in systemic, ethical, emotional, and physical reasoning within TempleOS. These games—`PsalmPuzzle.HC`, `ShepherdsQuest.HC`, `TempleBuilder.HC`, `ArkBuilder.HC`, `EdenRestorer.HC`, and `StarShepherd.HC`—offer engaging gameplay while advancing the AGI's capabilities, built for God's glory in the spirit of Terry A. Davis.

## Overview

Each game integrates with the AGI framework (located in `/Apps/`) to enhance the AGI's understanding of complex systems, ethical decision-making, and emotional resilience. The games leverage TempleOS's minimalist environment, supporting 640x480 16-color VGA, 512MB RAM, and 60FPS rendering. Biblical themes (e.g., Eden, Noah's Ark, celestial heavens) align with TempleOS's divine purpose, making these games both educational for the AGI and spiritually resonant.

### Games

1. **PsalmPuzzle** (`PsalmPuzzle.HC`):
   - **Description**: A tile-matching puzzle where players align biblical symbols to form verses, training the AGI in ethical feedback.
   - **Features**: 2D graphics, simple controls, ethical warnings for misaligned actions.
   - **AGI Training**: Updates `knowledge_graph` with pattern-matching metrics, adjusts `ethics` for righteous play.

2. **ShepherdsQuest** (`ShepherdsQuest.HC`):
   - **Description**: A text-based adventure where players guide a flock through a desert, training the AGI in emotional guidance.
   - **Features**: Resource management, text UI, emotional cues based on flock health.
   - **AGI Training**: Updates `knowledge_graph` with survival metrics, sets `emotion` based on challenges.

3. **TempleBuilder** (`TempleBuilder.HC`):
   - **Description**: A 2D construction simulation where players build a virtual temple, training the AGI in symbolic reasoning.
   - **Features**: Grid-based building, resource allocation, symbolic feedback.
   - **AGI Training**: Updates `knowledge_graph` with construction patterns, adjusts `ethics` for balanced resource use.

4. **ArkBuilder** (`ArkBuilder.HC`, `Physics.HC`):
   - **Description**: A 3D physics-based simulation where players build a stable ark, training the AGI in physical reasoning.
   - **Features**: Gravity, collisions, 3D/2D rendering, stability feedback.
   - **AGI Training**: Updates `knowledge_graph` with stability metrics, adjusts `ethics` for resource fairness.
   - **Dependency**: `Physics.HC` for gravitational and collision dynamics.

5. **EdenRestorer** (`EdenRestorer.HC`, `Ecology.HC`):
   - **Description**: A 3D/2D ecological simulation where players restore a corrupted Eden, training the AGI in systemic thinking.
   - **Features**: Population dynamics, resource cycles, pollution management, ethical/emotional feedback.
   - **AGI Training**: Updates `knowledge_graph` with ecosystem health, adjusts `ethics` for stewardship, sets `emotion` based on health trends.
   - **Dependency**: `Ecology.HC` for ecological dynamics.

6. **StarShepherd** (`StarShepherd.HC`, `Celestial.HC`):
   - **Description**: A 3D/2D celestial simulation where players guide stars to form divine patterns, ideal for background AGI simulation.
   - **Features**: N-body gravity, orbital dynamics, pattern alignment, low-resource design.
   - **AGI Training**: Updates `knowledge_graph` with alignment metrics, adjusts `ethics` for harmony, sets `emotion` based on pattern progress.
   - **Dependency**: `Celestial.HC` for gravitational dynamics.

## Directory Structure

/Games/
├── PsalmPuzzle.HC        # Tile-matching game
├── ShepherdsQuest.HC     # Text-based adventure
├── TempleBuilder.HC      # 2D construction simulation
├── ArkBuilder.HC         # 3D physics-based ark-building
├── Physics.HC            # Physics module for ArkBuilder
├── EdenRestorer.HC       # Ecological restoration simulation
├── Ecology.HC            # Ecological dynamics module
├── StarShepherd.HC       # Celestial pattern simulation
├── Celestial.HC          # Celestial dynamics module
├── Docs/                 # Documentation
│   └── README.md         # This README
└── Tests/                # (Optional) Test scripts

- **Docs/**: Contains this README and potential future guides.
- **Tests/**: Placeholder for test scripts to validate game mechanics or AGI integration.

## Installation

TempleOS lacks internet support, requiring file transfer via VHD, CD, or USB.

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
   - Reboot to load games.

## Usage

1. **Run a Game**:
   - Open a game script: `Ed("::/Games/StarShepherd.HC");` (or other game).
   - Press `F5` to start.
   - Alternatively: `StarShepherd;` (or other game name).
   - For background simulation (e.g., `StarShepherd`): `Spawn(&StarShepherd);`.

2. **Controls** (Game-Specific):
   - **PsalmPuzzle**: WASD to move cursor, Space to swap tiles, ESC to exit.
   - **ShepherdsQuest**: 1-4 to choose actions (search water/food, rest, move), ESC to exit.
   - **TempleBuilder**: 1-4 to place stone/wood, gather resources, hire worker, ESC to exit.
   - **ArkBuilder**: WASD/QE to move cursor, 1-4 to place wood/stone, gather, hire, IJKL for camera, ESC to exit.
   - **EdenRestorer**: WASD to move cursor, 1-4 to plant tree, clean water, gather, hire, IJKL for camera (3D), ESC to exit.
   - **StarShepherd**: WASD/IJKL to move/rotate camera, 1-3 to add star, nudge orbit, select star, ESC to exit.

3. **AGI Feedback**:
   - Ethical warnings if `ethics < 5` (e.g., resource overuse, collisions, extinction).
   - Emotional cues if `emotion == 3` (e.g., chaotic patterns, ecosystem distress).
   - Game-specific metrics (e.g., stability, health, alignment) update `knowledge_graph`.
   - Requires AGI framework files in `C:/Apps`.

## Debugging and Design

- **Memory**: Minimal dynamic allocations (e.g., `log_buffer`), freed on exit. Fixed-size arrays ensure 512MB RAM compatibility.
- **Bounds**: All grid, array, and index accesses are validated or clamped.
- **Error Handling**: Allocation failures are checked, and AGI calls are skipped if undefined.
- **Physics/Ecology/Celestial**: Capped calculations prevent numerical instability.
- **Rendering**: 3D games (`ArkBuilder`, `EdenRestorer`, `StarShepherd`) include 2D fallbacks for TempleOS 5.03 compatibility.
- **Background Simulation**: `StarShepherd` is optimized for low CPU/memory use, ideal for continuous AGI learning.

## Requirements

- **TempleOS**: Version 5.03 (2D mode) or compatible fork (ZealOS, Shrine) with 3D support.
- **AGI Framework**: `Temple-OS-AGI-Emergence` files (e.g., `AGI.HC`) in `C:/Apps` for full functionality.
- **Hardware**: 512MB RAM minimum.
- **Display**: 640x480, 16-color VGA.
- **Storage**: <1MB for game files.

## Contributing

1. Develop new games or simulation modules in HolyC.
2. Ensure compatibility with TempleOS and the AGI framework.
3. Submit pull requests or share via the TempleOS community.
4. Align contributions with the project's divine purpose.

## License

Public domain, dedicated to God's glory, per Terry A. Davis's vision.

## Acknowledgments

- Terry A. Davis for TempleOS and its graphics capabilities.
- @MyKey00110000 for the AGI framework inspiration.
- The TempleOS community for preserving the Third Temple.
