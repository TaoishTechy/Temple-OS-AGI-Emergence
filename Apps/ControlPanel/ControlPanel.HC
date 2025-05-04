// ControlPanel.HC - A Settings and System Information Manager for TempleOS
// Built in HolyC for efficiency and integration with TempleOS

// Constants for display
#define SCREEN_HEIGHT 25
#define SCREEN_WIDTH 80
#define MAX_MENU_ITEMS 10

// Menu item structure
class MenuItem {
  U8 name[32];
  U0 (*action)();
};

// Global state
MenuItem main_menu[MAX_MENU_ITEMS];
I64 menu_count = 0;
I64 selected_idx = 0;
I64 scroll_offset = 0;

// Settings (persisted to /Home/Settings.DAT)
class SystemSettings {
  U8 bg_color;    // Background color (0-15)
  U8 fg_color;    // Foreground color (0-15)
  U8 sound_on : 1; // Sound enabled/disabled
  U8 debug_mode : 1; // Debug mode for AGI simulations
};
SystemSettings settings;

// Utility: Clear the screen with a background color
U0 ClearScreen() {
  I64 i;
  for (i = 0; i < SCREEN_HEIGHT; i++) {
    Print("\n");
  }
  Text.Print("\x1B[4%dm", settings.bg_color); // Set background color
  Text.Print("\x1B[3%dm", settings.fg_color); // Set foreground color
}

// Utility: Display a header
U0 DisplayHeader() {
  Text.Print("\x1B[1;37m"); // White text, bold
  Print("TempleOS Control Panel - 'The Lord is my strength' (Ps 28:7)\n");
  Text.Print("\x1B[0m");
  Print("----------------------------------------\n");
}

// Utility: Display the menu
U0 DisplayMenu() {
  I64 i;
  I64 display_count = Min(menu_count - scroll_offset, SCREEN_HEIGHT - 5);

  for (i = 0; i < display_count; i++) {
    I64 idx = i + scroll_offset;
    if (idx == selected_idx) {
      Text.Print("\x1B[1;32m"); // Highlight selected entry in green
      Print(">");
    } else {
      Print(" ");
    }
    Print(" %s\n", main_menu[idx].name);
    Text.Print("\x1B[0m");
  }
  // Fill remaining lines
  for (i = display_count; i < SCREEN_HEIGHT - 5; i++) {
    Print("\n");
  }
  Print("----------------------------------------\n");
  Print("Enter: Select | Esc: Exit\n");
}

// Utility: Load settings from file
U0 LoadSettings() {
  U8 *data = FileRead("/Home/Settings.DAT");
  if (data) {
    MemCpy(&settings, data, sizeof(SystemSettings));
    Free(data);
  } else {
    // Default settings
    settings.bg_color = 4; // Dark blue
    settings.fg_color = 7; // White
    settings.sound_on = 1;
    settings.debug_mode = 0;
  }
}

// Utility: Save settings to file
U0 SaveSettings() {
  FileWrite("/Home/Settings.DAT", &settings, sizeof(SystemSettings));
}

// System Information Functions
U0 ShowSystemInfo() {
  ClearScreen();
  DisplayHeader();
  Print("System Information:\n");
  Print("----------------------------------------\n");

  // CPU Info
  Print("CPU: 64-bit, Speed: %d MHz\n", CPUGetSpeed / 1000000);

  // Memory Info
  U64 total_mem, used_mem;
  MemRep(&total_mem, &used_mem);
  Print("Memory: %d MB Total, %d MB Used\n", total_mem / 1048576, used_mem / 1048576);

  // Disk Info
  U64 disk_total, disk_free;
  DiskRep(&disk_total, &disk_free);
  Print("Disk: %d MB Total, %d MB Free\n", disk_total / 1048576, disk_free / 1048576);

  // Uptime and Date/Time
  U64 uptime = SysGetUptime;
  Print("Uptime: %d seconds\n", uptime / 1000);
  Print("Date/Time: %s\n", DateTimeStr);

  Print("----------------------------------------\n");
  Print("Press any key to return...\n");
  GetChar;
}

// AGI-Specific Information (Inspired by Temple-OS-AGI-Emergence)
U0 ShowAGIInfo() {
  ClearScreen();
  DisplayHeader();
  Print("AGI System Information:\n");
  Print("----------------------------------------\n");

  // Placeholder metrics (simulating data from Temple-OS-AGI-Emergence)
  Print("Quantum Mesh Efficiency: 90%%\n");
  Print("Knowledge Graph Nodes: 512\n");
  Print("Knowledge Retention: 85%%\n");
  Print("Simulation Debug Mode: %s\n", settings.debug_mode ? "On" : "Off");

  Print("----------------------------------------\n");
  Print("Press any key to return...\n");
  GetChar;
}

// Settings Adjustment Functions
U0 AdjustColors() {
  ClearScreen();
  DisplayHeader();
  Print("Adjust Colors:\n");
  Print("----------------------------------------\n");
  Print("Current Background: %d, Foreground: %d\n", settings.bg_color, settings.fg_color);
  Print("Enter new background color (0-15):\n");

  U8 input[4];
  StrCpy(input, "");
  I64 ch, i = 0;
  while (TRUE) {
    ch = GetChar;
    if (ch == '\n') break;
    if (ch == '\b' && i > 0) {
      i--;
      input[i] = 0;
      Print("\b \b");
    } else if (ch >= '0' && ch <= '9' && i < 3) {
      input[i] = ch;
      i++;
      input[i] = 0;
      Print("%c", ch);
    }
  }
  I64 new_bg = Str2I64(input);
  if (new_bg >= 0 && new_bg <= 15) settings.bg_color = new_bg;

  Print("\nEnter new foreground color (0-15):\n");
  StrCpy(input, "");
  i = 0;
  while (TRUE) {
    ch = GetChar;
    if (ch == '\n') break;
    if (ch == '\b' && i > 0) {
      i--;
      input[i] = 0;
      Print("\b \b");
    } else if (ch >= '0' && ch <= '9' && i < 3) {
      input[i] = ch;
      i++;
      input[i] = 0;
      Print("%c", ch);
    }
  }
  I64 new_fg = Str2I64(input);
  if (new_fg >= 0 && new_fg <= 15) settings.fg_color = new_fg;

  SaveSettings();
  Print("Colors updated. Press any key to return...\n");
  GetChar;
}

U0 ToggleSound() {
  ClearScreen();
  DisplayHeader();
  Print("Toggle Sound:\n");
  Print("----------------------------------------\n");
  settings.sound_on = !settings.sound_on;
  if (settings.sound_on) {
    Sound(1000, 100); // Test sound
    Print("Sound enabled.\n");
  } else {
    Print("Sound disabled.\n");
  }
  SaveSettings();
  Print("Press any key to return...\n");
  GetChar;
}

U0 ToggleDebugMode() {
  ClearScreen();
  DisplayHeader();
  Print("Toggle AGI Debug Mode:\n");
  Print("----------------------------------------\n");
  settings.debug_mode = !settings.debug_mode;
  Print("Debug Mode: %s\n", settings.debug_mode ? "On" : "Off");
  SaveSettings();
  Print("Press any key to return...\n");
  GetChar;
}

// Initialize the menu
U0 InitMenu() {
  menu_count = 0;
  StrCpy(main_menu[menu_count].name, "System Information");
  main_menu[menu_count].action = &ShowSystemInfo;
  menu_count++;
  StrCpy(main_menu[menu_count].name, "AGI System Information");
  main_menu[menu_count].action = &ShowAGIInfo;
  menu_count++;
  StrCpy(main_menu[menu_count].name, "Adjust Colors");
  main_menu[menu_count].action = &AdjustColors;
  menu_count++;
  StrCpy(main_menu[menu_count].name, "Toggle Sound");
  main_menu[menu_count].action = &ToggleSound;
  menu_count++;
  StrCpy(main_menu[menu_count].name, "Toggle AGI Debug Mode");
  main_menu[menu_count].action = &ToggleDebugMode;
  menu_count++;
}

// Main loop
U0 ControlPanel() {
  LoadSettings();
  InitMenu();

  I64 ch;
  while (TRUE) {
    ClearScreen();
    DisplayHeader();
    DisplayMenu();

    ch = GetChar;
    switch (ch) {
      case 0x1B: // Esc to exit
        return;

      case '\n': // Enter to select
        if (main_menu[selected_idx].action) {
          (*main_menu[selected_idx].action)();
        }
        break;

      case 0x4800: // Up arrow
        if (selected_idx > 0) {
          selected_idx--;
          if (selected_idx < scroll_offset) {
            scroll_offset--;
          }
        }
        break;

      case 0x5000: // Down arrow
        if (selected_idx < menu_count - 1) {
          selected_idx++;
          if (selected_idx >= scroll_offset + SCREEN_HEIGHT - 5) {
            scroll_offset++;
          }
        }
        break;
    }
  }
}

// Entry point
ControlPanel;
