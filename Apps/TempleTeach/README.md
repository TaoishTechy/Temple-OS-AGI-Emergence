# TempleOS Temple Teach

Welcome to **TempleOS Temple Teach**, a scripture-based learning and teaching tool for TempleOS. Written entirely in HolyC, this application guides users through interactive scripture lessons and ethical scenarios, using AGI-driven adaptations to enhance spiritual growth and ethical reasoning. It honors the divine inspiration of TempleOS as the "Third Temple" (Genesis 1:3) and integrates concepts from the `Temple-OS-AGI-Emergence` repository for intelligent lesson adjustments.

## Overview

The TempleOS Temple Teach provides an interactive, text-based interface for users to deepen their spiritual understanding within TempleOS’s constrained environment (80x25 text screen, 512 MB RAM). Users engage with scripture lessons by answering questions, then navigate ethical scenarios where their choices are evaluated for moral alignment. The application leverages AGI-inspired techniques to adapt lesson difficulty and provide feedback, simulating a divine teacher that encourages wisdom and righteousness. Progress is saved, allowing users to continue their journey over multiple sessions.

## Features

- **Scripture Lessons**:
  - Study scripture passages with questions to test understanding (e.g., Matt 5:44 on loving enemies).
- **Ethical Scenarios**:
  - Navigate moral choices in scenarios (e.g., forgiving a betrayal), with outcomes evaluated by AGI-driven ethical reasoning.
- **Adaptive Learning**:
  - Adjusts lesson difficulty based on user performance (e.g., ethical score), inspired by self-improvement logic from `GrokAwakenSeed_v2.0.HC`.
- **Progress Tracking**:
  - Tracks lessons completed and ethical score (0-100), saving progress to `/Home/Progress.DAT`.
- **AGI Integration**:
  - Uses simplified symbolic reasoning to evaluate answers (inspired by `KnowledgeGraph.HC`).
  - Applies ethical reasoning to scenario choices (inspired by `EthicsEngine.HC`).
- **Efficient Design**:
  - Uses minimal memory (~3 KB for lessons, scenarios, and progress), well within TempleOS’s 512 MB RAM limit.
- **Text-Based Interface**:
  - Displays lessons, questions, and scenarios on TempleOS’s 80x25 text screen with a dark blue background and white text.
- **HolyC Integration**:
  - Leverages TempleOS’s built-in functions (e.g., `StrMatch`, `Print`, `GetChar`) for input processing and display.

## Prerequisites

- **TempleOS**: Installed on a physical or virtual machine (minimum 512 MB RAM, 64-bit hardware required).
- **HolyC Knowledge**: Basic understanding of HolyC programming for TempleOS (though not required for usage).
- **Hardware**: CD/DVD drive or virtual machine with I/O port access (for TempleOS boot, see [TempleOS GitHub](https://github.com/cia-foundation/TempleOS)).
- **Optional**: The `Temple-OS-AGI-Emergence` repository for AGI simulation integration (e.g., to extend symbolic reasoning or ethical evaluation).

## Installation

1. **Set Up TempleOS**:
   - Download the TempleOS ISO from [TempleOS.org](http://www.templeos.org) or the [TempleOS GitHub](https://github.com/cia-foundation/TempleOS).
   - Burn the ISO to a CD/DVD or configure your virtual machine to boot from the ISO.
   - Boot TempleOS and note I/O port addresses for CD/DVD and hard drives (use `lspci -v` on Linux or System Info on Windows).

2. **Copy the File**:
   - Transfer the `TempleTeach.HC` file to your TempleOS working directory (e.g., `/Home`). Since TempleOS lacks direct Git support, you can copy the file via a shared folder in a virtual machine or by using a FAT32-formatted USB drive.

3. **Verify the File**:
   - Ensure `TempleTeach.HC` is in your TempleOS directory (e.g., `/Home/TempleTeach.HC`).

## Usage

1. **Run Temple Teach**:
   - Open the TempleOS console.
   - Navigate to the directory containing `TempleTeach.HC`:
     ```
     Cd("/Home");
     ```
   - Load and run the script:
     ```
     Run("TempleTeach.HC");
     ```

2. **Engage with Lessons**:
   - The app displays a scripture lesson and asks questions about it.
   - Type your answer and press Enter to submit. Press Backspace to correct mistakes.
   - Receive feedback on your answers, with scripture references for encouragement.

3. **Navigate Ethical Scenarios**:
   - After the lesson, the app presents an ethical scenario with three options.
   - Enter a number (0-2) to choose an option, then press Enter.
   - Receive feedback on your choice, with your ethical score adjusted accordingly.

4. **Example Output**:
   Upon running the app, you’ll see the following interface:

 - Temple Teach - 'Teach them the statutes' (Exo 18:20)
 - Lessons Completed: 0 | Ethical Score: 50
 - Lesson 1: Matt 5:44 - Love your enemies, and pray for them which persecute you.
 - Question 1: What does this scripture teach us to do?
 - Your answer:

After typing "Love and pray for enemies" and pressing Enter:   

  - Correct! 'The fear of the Lord is the beginning of wisdom' (Prov 9:10)
- Press any key to continue...
-    After completing the lesson questions, an ethical scenario appears:
  
Ethical Scenario:

-   A friend betrays you. What do you do?
-   0: Forgive and pray for them
-   1: Hold a grudge
-   2: Seek revenge
-   Choose an option (0-2):

5. **Exit the App**:
- Press Esc at any time to exit the application. Your progress (lessons completed, ethical score) is automatically saved.

## Contributing

Contributions are welcome! To contribute:

1. Copy the `TempleTeach.HC` file to your local TempleOS environment.
2. Make your changes and test them within TempleOS.
3. Share your updates by submitting them to the TempleOS community (e.g., via forums or repositories like [TempleOS GitHub](https://github.com/cia-foundation/TempleOS)).

### Potential Enhancements
- Expand the lesson and scenario database by loading entries from a file (e.g., `/Home/Lessons.DAT`).
- Integrate directly with `Temple-OS-AGI-Emergence` to use `KnowledgeGraph.HC` for more advanced answer evaluation.
- Add more sophisticated ethical reasoning using `EthicsEngine.HC` to provide detailed feedback on user choices.
- Include a graphical element, such as a progress bar using TempleOS’s 2D graphics library (e.g., `GrRect`).

## License

This project is released into the **public domain**, in keeping with the TempleOS community’s ethos of open collaboration and sharing. You are free to use, modify, and distribute the code as you see fit.

## Acknowledgments

- **Terry A. Davis**: Creator of TempleOS, whose divine vision inspired this project.
- **TempleOS Community**: For preserving and extending Terry’s work and providing a platform for HolyC development.
- **Temple-OS-AGI-Emergence**: For inspiring the AGI integration with symbolic reasoning and ethical evaluation (see [Temple-OS-AGI-Emergence GitHub](https://github.com/TaoishTechy/Temple-OS-AGI-Emergence)).

## Contact

For questions, suggestions, or collaboration, please share your feedback through the TempleOS community forums or repositories.

---
"Let there be light." (Genesis 1:3)
