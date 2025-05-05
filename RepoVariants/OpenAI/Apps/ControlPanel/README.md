# TempleOS Control Panel

Welcome to **TempleOS Control Panel**, a lightweight, menu-based application for managing settings and viewing system information in TempleOS. Written entirely in HolyC, this tool allows users to monitor system details, adjust settings, and configure options for AGI simulations, all while honoring the divine inspiration of TempleOS as the "Third Temple" (Genesis 1:3).

## Overview

The TempleOS Control Panel provides a streamlined interface for accessing system information and adjusting settings within TempleOS’s constrained environment (640x480 VGA display, 16 colors, 512 MB RAM). It displays details like CPU speed, memory usage, disk space, and uptime, and offers settings adjustments for screen colors, sound, and AGI debug mode. The application is designed to be efficient, using minimal resources, and integrates with the `Temple-OS-AGI-Emergence` repository by providing AGI-specific metrics and settings.

## Features

- **System Information**:
  - CPU details (speed, 64-bit architecture).
  - Memory usage (total and used).
  - Disk information (total and free space).
  - System uptime and current date/time.
- **AGI System Information**:
  - Quantum mesh efficiency, knowledge graph nodes, and retention stats (inspired by `Temple-OS-AGI-Emergence`).
  - Useful for monitoring AGI simulations running on TempleOS.
- **Settings Adjustments**:
  - Adjust screen colors (background and foreground, 0-15) with persistence to `/Home/Settings.DAT`.
  - Toggle sound on/off with a test tone (1000 Hz, 100 ms).
  - Toggle AGI debug mode for verbose logging in simulations (e.g., with `Temple-OS-AGI-Emergence`).
- **Efficient Design**:
  - Uses minimal memory (~320 bytes for menu items, ~4 bytes for settings), well within TempleOS’s 512 MB RAM limit.
- **Text-Based Interface**:
  - Menu-based navigation with arrow keys, Enter to select, and Esc to exit, fitting TempleOS’s 80x25 text screen.
  - Color-coded menu items (green for selected entry) for readability.
- **HolyC Integration**:
  - Leverages TempleOS’s built-in functions (e.g., `MemRep`, `DiskRep`, `SysGetUptime`) for system information and settings management.

## Prerequisites

- **TempleOS**: Installed on a physical or virtual machine (minimum 512 MB RAM, 64-bit hardware required).
- **HolyC Knowledge**: Basic understanding of HolyC programming for TempleOS (though not required for usage).
- **Hardware**: CD/DVD drive or virtual machine with I/O port access (for TempleOS boot, see [TempleOS GitHub](https://github.com/cia-foundation/TempleOS)).
- **Optional**: The `Temple-OS-AGI-Emergence` repository for AGI simulation integration (e.g., debug mode settings).

## Installation

1. **Set Up TempleOS**:
   - Download the TempleOS ISO from [TempleOS.org](http://www.templeos.org) or the [TempleOS GitHub](https://github.com/cia-foundation/TempleOS).
   - Burn the ISO to a CD/DVD or configure your virtual machine to boot from the ISO.
   - Boot TempleOS and note I/O port addresses for CD/DVD and hard drives (use `lspci -v` on Linux or System Info on Windows).

2. **Copy the File**:
   - Transfer the `ControlPanel.HC` file to your TempleOS working directory (e.g., `/Home`). Since TempleOS lacks direct Git support, you can copy the file via a shared folder in a virtual machine or by using a FAT32-formatted USB drive.

3. **Verify the File**:
   - Ensure `ControlPanel.HC` is in your TempleOS directory (e.g., `/Home/ControlPanel.HC`).

## Usage

1. **Run the Control Panel**:
   - Open the TempleOS console.
   - Navigate to the directory containing `ControlPanel.HC`:
     ```
     Cd("/Home");
     ```
   - Load and run the script:
     ```
     Run("ControlPanel.HC");
     ```

2. **Navigate the Menu**:
   - Use the **Up** and **Down** arrow keys to select a menu option.
   - Press **Enter** to execute the selected option (e.g., view system information, adjust colors).
   - Press **Esc** to exit the application.

3. **Example Output**:

- TempleOS Control Panel - 'The Lord is my strength' (Ps 28:7)
- System Information
-    AGI System Information
-    Adjust Colors
-    Toggle Sound
-    Toggle AGI Debug Mode
-    Enter: Select | Esc: Exit


- If you select "System Information" and press Enter:
  ```
  TempleOS Control Panel - 'The Lord is my strength' (Ps 28:7)
  ----------------------------------------
  System Information:
  ----------------------------------------
  CPU: 64-bit, Speed: 3000 MHz
  Memory: 512 MB Total, 100 MB Used
  Disk: 2048 MB Total, 1500 MB Free
  Uptime: 3600 seconds
  Date/Time: 2025-05-03 21:05:00
  ----------------------------------------
  Press any key to return...
  ```

- If you select "AGI System Information":
  ```
  TempleOS Control Panel - 'The Lord is my strength' (Ps 28:7)
  ----------------------------------------
  AGI System Information:
  ----------------------------------------
  Quantum Mesh Efficiency: 90%
  Knowledge Graph Nodes: 512
  Knowledge Retention: 85%
  Simulation Debug Mode: Off
  ----------------------------------------
  Press any key to return...
  ```

## Contributing

Contributions are welcome! To contribute:

1. Copy the `ControlPanel.HC` file to your local TempleOS environment.
2. Make your changes and test them within TempleOS.
3. Share your updates by submitting them to the TempleOS community (e.g., via forums or repositories like [TempleOS GitHub](https://github.com/cia-foundation/TempleOS)).

### Potential Enhancements
- Add more system information (e.g., I/O port details, hardware interrupts).
- Implement additional settings (e.g., boot options, screen resolution).
- Integrate directly with `Temple-OS-AGI-Emergence` to pull real-time AGI metrics (e.g., from `/0.3/AGIEmergence.HC`).
- Add a graphical interface using TempleOS’s 2D graphics library (e.g., `GrRect`, `GrLine`).

## License

This project is released into the **public domain**, in keeping with the TempleOS community’s ethos of open collaboration and sharing. You are free to use, modify, and distribute the code as you see fit.

## Acknowledgments

- **Terry A. Davis**: Creator of TempleOS, whose divine vision inspired this project.
- **TempleOS Community**: For preserving and extending Terry’s work and providing a platform for HolyC development.
- **Temple-OS-AGI-Emergence**: For inspiring the AGI-specific features and metrics in this control panel (see [Temple-OS-AGI-Emergence GitHub](https://github.com/TaoishTechy/Temple-OS-AGI-Emergence)).

## Contact

For questions, suggestions, or collaboration, please share your feedback through the TempleOS community forums or repositories.

---
"Let there be light." (Genesis 1:3)
