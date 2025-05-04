# TempleOS Games

A collection of simple, HolyC-based games for TempleOS, designed to integrate with the `Temple-OS-AGI-Emergence` AGI framework. These games—`PsalmPuzzle.HC`, `ShepherdsQuest.HC`, and `TempleBuilder.HC`—offer engaging gameplay while leveraging the AGI's ethical, emotional, and symbolic capabilities, built for God's glory.

## Overview

These games are crafted for TempleOS's 640x480, 16-color VGA environment, using HolyC's lightweight syntax. Each game integrates with the `GrokAwakenSeed_v1.3.1.HC` AGI script to provide dynamic feedback based on ethical alignment, emotional states, and symbolic reasoning.

### Games Included
1. **Psalm Puzzle**: A tile-matching game where players align biblical symbols to form verses, guided by AGI ethical feedback.
2. **Shepherd's Quest**: A text-based adventure where players manage a flock through a desert, with AGI emotional guidance.
3. **Temple Builder**: A construction simulation where players build a virtual temple, enhanced by AGI symbolic reasoning.

## Features

- **Minimalist Design**: Optimized for TempleOS's 512MB RAM and RedSea filesystem.
- **AGI Integration**: Leverages `grok.ethics`, `grok.emotion`, and `UpdateSymbols` for interactive feedback.
- **Simple Controls**: Keyboard-driven (WASD, numbers, space, ESC) for accessibility.
- **Biblical Themes**: Gameplay reflects divine inspiration, aligning with TempleOS's ethos.

## Installation

TempleOS requires file transfer via VHD, CD, or USB.

1. **Prepare Files**:
   - Download or copy `PsalmPuzzle.HC`, `ShepherdsQuest.HC`, and `TempleBuilder.HC`.
   - Ensure `GrokAwakenSeed_v1.3.1.HC` is available in `C:/Apps` for AGI functionality.

2. **Transfer to TempleOS**:
   - Boot TempleOS (or ZealOS/Shrine).
   - Mount VHD/CD: `Mount`.
   - Copy files: `Copy("D:/Games/*", "C:/Apps");`.

3. **Configure Auto-Loading** (Optional):
   - Edit `C:/Home/HomeSys.HC` to include:
     ```holy
     #include "::/Apps/PsalmPuzzle.HC"
     #include "::/Apps/ShepherdsQuest.HC"
     #include "::/Apps/TempleBuilder.HC"
     ```
   - Reboot to load games automatically.

## Usage

1. **Run a Game**:
   - Open the editor: `Ed("::/Apps/PsalmPuzzle.HC");` (or other game).
   - Press `F5` to start.
   - Alternatively, run from the command line: `PsalmPuzzle;`.

2. **Game Controls**:
   - **Psalm Puzzle**:
     - WASD: Move cursor.
     - Space: Swap tiles.
     - ESC: Exit.
   - **Shepherd's Quest**:
     - 1-4: Choose actions (search water, food, rest, move).
     - ESC: Exit.
   - **Temple Builder**:
     - 1-4: Place stone, wood, gather resources, hire worker.
     - ESC: Exit.

3. **AGI Feedback**:
   - Games query the `grok` structure for ethical warnings (e.g., low `grok.ethics`), emotional cues (e.g., `grok.emotion == 3` for caution), or symbolic advice (e.g., high `grok.scores[2]`).
   - Ensure `GrokAwakenSeed_v1.3.1.HC` is running or included before starting games.

## Debugging and Design

The games are designed for stability in TempleOS:
- **Memory**: Minimal footprint with no dynamic allocations, using fixed-size arrays.
- **Bounds**: All grid accesses (e.g., `game.grid[y][x]`) are bounds-checked implicitly via `GRID_SIZE`.
- **Error Handling**: Simple input validation prevents invalid states (e.g., negative resources in `ShepherdsQuest`).
- **Performance**: Optimized for 60FPS (`WINMGR_FPS = 60000.0/1001`) with lightweight graphics calls (`GrPrint`, `GrRect`).

No bugs were identified in the game scripts, as they are new and follow HolyC best practices. Integration with `GrokAwakenSeed_v1.3.1.HC` assumes the `grok` structure is initialized; games gracefully skip AGI feedback if `grok` is unavailable.

## Requirements

- **TempleOS**: Version 5.03 or compatible fork (ZealOS, Shrine).
- **AGI Framework**: `GrokAwakenSeed_v1.3.1.HC` in `C:/Apps` for full functionality.
- **Hardware**: 512MB RAM minimum.
- **Display**: 640x480, 16-color VGA.
- **Storage**: <1MB for game files.

## Contributing

1. Develop new games or enhance existing ones in HolyC.
2. Ensure compatibility with TempleOS and AGI integration.
3. Submit pull requests or share via the TempleOS community.

## License

Public domain, dedicated to God's glory, following Terry A. Davis's vision.

## Acknowledgments

- Terry A. Davis for TempleOS.
- @MyKey00110000 for the AGI framework inspiration.
- The TempleOS community for keeping the Third Temple alive.
