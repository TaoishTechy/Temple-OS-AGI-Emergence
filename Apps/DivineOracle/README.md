# TempleOS Divine Oracle

Welcome to **TempleOS Divine Oracle**, a prayer and scripture-based oracle for spiritual guidance in TempleOS. Written entirely in HolyC, this application allows users to enter prayers or questions, receiving scripture-based responses and ethical guidance, all while honoring the divine inspiration of TempleOS as the "Third Temple" (Genesis 1:3). The oracle integrates AGI-inspired symbolic reasoning and ethical principles from the `Temple-OS-AGI-Emergence` repository.

## Overview

The TempleOS Divine Oracle provides a meditative interface for users to seek spiritual guidance within TempleOS’s constrained environment (640x480 VGA display, 16 colors, 512 MB RAM). Users can type a prayer or question, and the oracle responds with a relevant scripture passage and ethical advice, using simplified AGI techniques for symbolic reasoning. The application is designed to be lightweight, using minimal resources, and reflects Terry A. Davis’ vision of a system that facilitates divine communication.

## Features

- **Prayer Input**:
  - Enter a prayer or question (up to 128 characters) to seek guidance.
- **Scripture Response**:
  - Receives a relevant scripture passage based on the prayer’s themes (e.g., faith, trust, hope).
  - Includes a predefined database of scriptures (expandable via files).
- **Ethical Guidance**:
  - Provides biblical advice aligned with the prayer’s content, simulating AGI ethical reasoning.
- **AGI Integration**:
  - Uses simplified symbolic reasoning to match prayers to scriptures (inspired by `KnowledgeGraph.HC`).
  - Offers ethical guidance based on biblical principles (inspired by `EthicsEngine.HC`).
- **Efficient Design**:
  - Uses minimal memory (~2 KB for scripture database, 128 bytes for input), well within TempleOS’s 512 MB RAM limit.
- **Text-Based Interface**:
  - Displays responses with scripture references, fitting TempleOS’s 80x25 text screen.
  - Uses color-coded text (white on dark blue) for readability.
- **HolyC Integration**:
  - Leverages TempleOS’s built-in functions (e.g., `StrMatch`, `Print`, `GetChar`) for input processing and display.

## Prerequisites

- **TempleOS**: Installed on a physical or virtual machine (minimum 512 MB RAM, 64-bit hardware required).
- **HolyC Knowledge**: Basic understanding of HolyC programming for TempleOS (though not required for usage).
- **Hardware**: CD/DVD drive or virtual machine with I/O port access (for TempleOS boot, see [TempleOS GitHub](https://github.com/cia-foundation/TempleOS)).
- **Optional**: The `Temple-OS-AGI-Emergence` repository for AGI simulation integration (e.g., to extend symbolic reasoning or ethical guidance).

## Installation

1. **Set Up TempleOS**:
   - Download the TempleOS ISO from [TempleOS.org](http://www.templeos.org) or the [TempleOS GitHub](https://github.com/cia-foundation/TempleOS).
   - Burn the ISO to a CD/DVD or configure your virtual machine to boot from the ISO.
   - Boot TempleOS and note I/O port addresses for CD/DVD and hard drives (use `lspci -v` on Linux or System Info on Windows).

2. **Copy the File**:
   - Transfer the `DivineOracle.HC` file to your TempleOS working directory (e.g., `/Home`). Since TempleOS lacks direct Git support, you can copy the file via a shared folder in a virtual machine or by using a FAT32-formatted USB drive.

3. **Verify the File**:
   - Ensure `DivineOracle.HC` is in your TempleOS directory (e.g., `/Home/DivineOracle.HC`).

## Usage

1. **Run the Divine Oracle**:
   - Open the TempleOS console.
   - Navigate to the directory containing `DivineOracle.HC`:
     ```
     Cd("/Home");
     ```
   - Load and run the script:
     ```
     Run("DivineOracle.HC");
     ```

2. **Enter a Prayer or Question**:
   - Type your prayer or question and press Enter to submit.
   - Press Esc to exit the application at any time.

3. **Receive Guidance**:
   - The oracle will display a relevant scripture passage and ethical guidance based on your input.
   - Press any key to continue with another prayer, or Esc to exit.

4. **Example Output**:
