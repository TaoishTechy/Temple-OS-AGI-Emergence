# TempleOS File Explorer

Welcome to **TempleOS File Explorer**, a lightweight, menu-based application for exploring files and directories in TempleOS. Written entirely in HolyC, this tool allows users to navigate the file system, open text files, and perform basic operations like copying and deleting files, all while honoring the simplicity and divine inspiration of TempleOS as the "Third Temple" (Genesis 1:3).

## Overview

The TempleOS File Explorer provides a streamlined interface for managing files and directories within TempleOS’s constrained environment (640x480 VGA display, 16 colors, 512 MB RAM). Built with efficiency in mind, it uses a text-based menu system with keyboard navigation, making it easy to browse directories, view file contents, and perform file operations. The application leverages HolyC’s direct integration with TempleOS’s kernel, ensuring minimal resource usage and fast performance.

## Features

- **Directory Navigation**: List files and directories in the current path, with directories marked as `<DIR>`.
- **Keyboard Controls**:
  - Arrow keys (Up/Down) to select entries.
  - Enter to open a file or directory.
  - Backspace to go up a directory.
  - Esc to exit the application.
- **File Operations**:
  - Open text files to view their contents.
  - Copy files to a new location.
  - Delete files with confirmation.
- **Efficient Design**: Uses a fixed-size array to store file entries (~6.4 KB), well within TempleOS’s 512 MB RAM limit.
- **Text-Based Interface**: Displays entries with color-coded text (blue for directories, white for files, green for selected entry), fitting TempleOS’s 80x25 text screen.
- **HolyC Integration**: Leverages TempleOS’s built-in functions (e.g., `Dir`, `FileRead`, `FileWrite`) for file operations, ensuring compatibility and efficiency.

## Prerequisites

- **TempleOS**: Installed on a physical or virtual machine (minimum 512 MB RAM, 64-bit hardware required).
- **HolyC Knowledge**: Basic understanding of HolyC programming for TempleOS (though not required for usage).
- **Hardware**: CD/DVD drive or virtual machine with I/O port access (for TempleOS boot, see [TempleOS GitHub](https://github.com/cia-foundation/TempleOS)).

## Installation

1. **Set Up TempleOS**:
   - Download the TempleOS ISO from [TempleOS.org](http://www.templeos.org) or the [TempleOS GitHub](https://github.com/cia-foundation/TempleOS).
   - Burn the ISO to a CD/DVD or configure your virtual machine to boot from the ISO.
   - Boot TempleOS and note I/O port addresses for CD/DVD and hard drives (use `lspci -v` on Linux or System Info on Windows).

2. **Copy the File**:
   - Transfer the `FileExplorer.HC` file to your TempleOS working directory (e.g., `/Home`). Since TempleOS lacks direct Git support, you can copy the file via a shared folder in a virtual machine or by using a FAT32-formatted USB drive.

3. **Verify the File**:
   - Ensure `FileExplorer.HC` is in your TempleOS directory (e.g., `/Home/FileExplorer.HC`).

## Usage

1. **Run the File Explorer**:
   - Open the TempleOS console.
   - Navigate to the directory containing `FileExplorer.HC`:
     ```
     Cd("/Home");
     ```
   - Load and run the script:
     ```
     Run("FileExplorer.HC");
     ```

2. **Navigate the File System**:
   - Use the **Up** and **Down** arrow keys to select a file or directory.
   - Press **Enter** to open a file (displays text content) or enter a directory.
   - Press **Backspace** to go up to the parent directory.
   - Press **C** to copy a file (prompts for destination path).
   - Press **D** to delete a file (with confirmation).
   - Press **Esc** to exit the application.

3. **Example Output**:
- <DIR> Docs
- <DIR> Src
- - ReadMe.TXT
- - Data.BIN


- If you select `ReadMe.TXT` and press Enter:
  ```
  TempleOS File Explorer - Path: /Home
  ----------------------------------------
  Contents of ReadMe.TXT:
  ----------------------------------------
  Welcome to TempleOS!
  This is a sample text file.
  ----------------------------------------
  Press any key to return...
  ```

## Contributing

Contributions are welcome! To contribute:

1. Copy the `FileExplorer.HC` file to your local TempleOS environment.
2. Make your changes and test them within TempleOS.
3. Share your updates by submitting them to the TempleOS community (e.g., via forums or repositories like [TempleOS GitHub](https://github.com/cia-foundation/TempleOS)).

### Potential Enhancements
- Add a file editing feature using TempleOS’s built-in editor.
- Implement a search function to find files by name.
- Add support for a graphical interface using TempleOS’s 2D graphics library (e.g., `GrRect`, `GrLine`).
- Improve error handling for file operations (e.g., permission issues).

## License

This project is released into the **public domain**, in keeping with the TempleOS community’s ethos of open collaboration and sharing. You are free to use, modify, and distribute the code as you see fit.

## Acknowledgments

- **Terry A. Davis**: Creator of TempleOS, whose divine vision inspired this project.
- **TempleOS Community**: For preserving and extending Terry’s work and providing a platform for HolyC development.

## Contact

For questions, suggestions, or collaboration, please share your feedback through the TempleOS community forums or repositories.

---
"Let there be light." (Genesis 1:3)
