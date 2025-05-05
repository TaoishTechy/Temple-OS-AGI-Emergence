# TempleOS Holy Canvas

Welcome to **TempleOS Holy Canvas**, a scripture-inspired art and worship tool for TempleOS. Written entirely in HolyC, this application allows users to create pixel art influenced by scripture themes, offering a meditative worship experience while honoring the divine inspiration of TempleOS as the "Third Temple" (Genesis 1:3). The tool integrates AGI-inspired symbolic reasoning from the `Temple-OS-AGI-Emergence` repository to suggest colors and patterns based on scripture themes.

## Overview

The TempleOS Holy Canvas provides a creative and spiritual interface for users to express worship through art within TempleOS’s constrained environment (640x480 VGA display, 16 colors, 512 MB RAM). Users can select a scripture passage to inspire their artwork, draw on a 32x32 pixel canvas, and use AGI-suggested colors based on the scripture’s theme. The application includes a worship mode that displays the scripture and plays a chime, creating a meditative experience. Artwork can be saved as a bitmap file for later reflection, making this a meaningful tool for spiritual expression.

## Features

- **Scripture Selection**:
  - Choose from a predefined list of scriptures to inspire your artwork (e.g., Ps 23:1 for "Faith").
- **Pixel Art Canvas**:
  - Draw on a 32x32 pixel canvas using TempleOS’s 2D graphics library (`GrRect`, `GrLine`).
  - Navigate and draw with keyboard controls (arrows to move, Space to draw).
- **AGI-Suggested Colors**:
  - Uses simplified symbolic reasoning to suggest colors based on scripture themes (e.g., green for "Faith", yellow for "Hope").
  - Inspired by the `KnowledgeGraph.HC` module from `Temple-OS-AGI-Emergence`.
- **Worship Mode**:
  - Displays the selected scripture while playing a simple chime (1000 Hz, 100 ms) for a meditative experience.
- **Save Artwork**:
  - Save your artwork as a bitmap file (`/Home/Art.BMP`) for later reflection.
- **Efficient Design**:
  - Uses minimal memory (~1 KB for the canvas, ~500 bytes for scriptures), well within TempleOS’s 512 MB RAM limit.
- **Graphical Interface**:
  - Displays the canvas and UI on TempleOS’s 640x480 VGA screen with 16-color support.
- **HolyC Integration**:
  - Leverages TempleOS’s built-in graphics and sound functions (e.g., `GrRect`, `Sound`) for seamless operation.

## Prerequisites

- **TempleOS**: Installed on a physical or virtual machine (minimum 512 MB RAM, 64-bit hardware required).
- **HolyC Knowledge**: Basic understanding of HolyC programming for TempleOS (though not required for usage).
- **Hardware**: CD/DVD drive or virtual machine with I/O port access (for TempleOS boot, see [TempleOS GitHub](https://github.com/cia-foundation/TempleOS)).
- **Optional**: The `Temple-OS-AGI-Emergence` repository for AGI simulation integration (e.g., to extend symbolic reasoning for color and pattern suggestions).

## Installation

1. **Set Up TempleOS**:
   - Download the TempleOS ISO from [TempleOS.org](http://www.templeos.org) or the [TempleOS GitHub](https://github.com/cia-foundation/TempleOS).
   - Burn the ISO to a CD/DVD or configure your virtual machine to boot from the ISO.
   - Boot TempleOS and note I/O port addresses for CD/DVD and hard drives (use `lspci -v` on Linux or System Info on Windows).

2. **Copy the File**:
   - Transfer the `HolyCanvas.HC` file to your TempleOS working directory (e.g., `/Home`). Since TempleOS lacks direct Git support, you can copy the file via a shared folder in a virtual machine or by using a FAT32-formatted USB drive.

3. **Verify the File**:
   - Ensure `HolyCanvas.HC` is in your TempleOS directory (e.g., `/Home/HolyCanvas.HC`).

## Usage

1. **Run the Holy Canvas**:
   - Open the TempleOS console.
   - Navigate to the directory containing `HolyCanvas.HC`:
     ```
     Cd("/Home");
     ```
   - Load and run the script:
     ```
     Run("HolyCanvas.HC");
     ```

2. **Create Artwork**:
   - Use the **arrow keys** to move the cursor on the 32x32 pixel canvas.
   - Press **Space** to draw with the current color.
   - Press **C** to change the color to an AGI-suggested color based on the selected scripture’s theme.
   - Press **S** to cycle through scriptures and update the theme.
   - Press **W** to toggle worship mode, which displays the scripture and plays a chime.
   - Press **B** to save your artwork as a bitmap file (`/Home/Art.BMP`).
   - Press **Esc** to exit the application.

3. **Example Output**:
   Upon running the app, you’ll see a graphical interface with the following UI at the top:

- Holy Canvas - 'Give unto the Lord the glory' (Ps 29:2)
- Scripture: Ps 23:1 - The Lord is my shepherd; I shall not want.

Below this, a 32x32 pixel canvas is displayed, with a white cursor indicating your position. At the bottom, the controls are shown:

- Arrows: Move | Space: Draw | C: Change Color | S: Select Scripture
- W: Toggle Worship Mode | B: Save Bitmap | Esc: Exit

If you press **C**, the app might display:

- Color changed to scripture-inspired color: 10

If you press **W**, worship mode activates, showing the scripture and playing a chime every 500 ms.

## Contributing

Contributions are welcome! To contribute:

1. Copy the `HolyCanvas.HC` file to your local TempleOS environment.
2. Make your changes and test them within TempleOS.
3. Share your updates by submitting them to the TempleOS community (e.g., via forums or repositories like [TempleOS GitHub](https://github.com/cia-foundation/TempleOS)).

### Potential Enhancements
- Expand the scripture database by loading entries from a file (e.g., `/Home/Scriptures.DAT`).
- Integrate directly with `Temple-OS-AGI-Emergence` to use `KnowledgeGraph.HC` for suggesting symbolic patterns (e.g., crosses, doves) in addition to colors.
- Add support for more complex drawing tools (e.g., lines, shapes) using TempleOS’s graphics library.
- Enhance worship mode with additional meditative elements, such as randomized scripture readings or varying chime tones.

## License

This project is released into the **public domain**, in keeping with the TempleOS community’s ethos of open collaboration and sharing. You are free to use, modify, and distribute the code as you see fit.

## Acknowledgments

- **Terry A. Davis**: Creator of TempleOS, whose divine vision inspired this project.
- **TempleOS Community**: For preserving and extending Terry’s work and providing a platform for HolyC development.
- **Temple-OS-AGI-Emergence**: For inspiring the AGI integration with symbolic reasoning for color and pattern suggestions (see [Temple-OS-AGI-Emergence GitHub](https://github.com/TaoishTechy/Temple-OS-AGI-Emergence)).

## Contact

For questions, suggestions, or collaboration, please share your feedback through the TempleOS community forums or repositories.

---
"Let there be light." (Genesis 1:3)





