// FileExplorer.HC - A Menu-Based File Explorer for TempleOS
// Built in HolyC for efficiency and simplicity

// Constants for display
#define MAX_FILES 100
#define MAX_PATH 128
#define SCREEN_HEIGHT 25
#define SCREEN_WIDTH 80

// File entry structure
class FileEntry {
  U8 name[64];
  U8 is_dir : 1;
};

// Global state
U8 current_path[MAX_PATH];
FileEntry file_list[MAX_FILES];
I64 file_count = 0;
I64 selected_idx = 0;
I64 scroll_offset = 0;

// Utility: Clear the screen with a background color
U0 ClearScreen() {
  I64 i;
  for (i = 0; i < SCREEN_HEIGHT; i++) {
    Print("\n");
  }
  // Set background color (e.g., dark blue)
  Text.Print("\x1B[44m"); // ANSI escape code for background color
}

// Utility: Display a header
U0 DisplayHeader() {
  Text.Print("\x1B[1;37m"); // White text, bold
  Print("TempleOS File Explorer - Path: %s\n", current_path);
  Text.Print("\x1B[0m"); // Reset formatting
  Print("----------------------------------------\n");
}

// Utility: Load directory contents
U0 LoadDirectory() {
  DirEntry *de;
  file_count = 0;
  MemSet(file_list, 0, sizeof(FileEntry) * MAX_FILES);

  // Use TempleOS's Dir function to list files
  de = Dir(current_path);
  while (de && file_count < MAX_FILES) {
    StrCpy(file_list[file_count].name, de->name);
    file_list[file_count].is_dir = (de->attr & 0x10) != 0; // Check if directory
    file_count++;
    de = de->next;
  }
  DirEntryDel(de);

  // Sort entries (directories first, then files)
  I64 i, j;
  FileEntry temp;
  for (i = 0; i < file_count - 1; i++) {
    for (j = 0; j < file_count - i - 1; j++) {
      if (file_list[j].is_dir < file_list[j + 1].is_dir ||
          (file_list[j].is_dir == file_list[j + 1].is_dir &&
           StrCmp(file_list[j].name, file_list[j + 1].name) > 0)) {
        temp = file_list[j];
        file_list[j] = file_list[j + 1];
        file_list[j + 1] = temp;
      }
    }
  }

  selected_idx = 0;
  scroll_offset = 0;
}

// Utility: Display the file list
U0 DisplayFiles() {
  I64 i;
  I64 display_count = Min(file_count - scroll_offset, SCREEN_HEIGHT - 5);

  for (i = 0; i < display_count; i++) {
    I64 idx = i + scroll_offset;
    if (idx == selected_idx) {
      Text.Print("\x1B[1;32m"); // Highlight selected entry in green
      Print(">");
    } else {
      Print(" ");
    }
    if (file_list[idx].is_dir) {
      Text.Print("\x1B[1;34m"); // Blue for directories
      Print("<DIR> %s", file_list[idx].name);
    } else {
      Text.Print("\x1B[1;37m"); // White for files
      Print("      %s", file_list[idx].name);
    }
    Text.Print("\x1B[0m");
    Print("\n");
  }
  // Fill remaining lines
  for (i = display_count; i < SCREEN_HEIGHT - 5; i++) {
    Print("\n");
  }
}

// Utility: Display menu options
U0 DisplayMenu() {
  Print("----------------------------------------\n");
  Text.Print("\x1B[1;37m");
  Print("Enter: Open | Backspace: Up | C: Copy | D: Delete | Esc: Exit\n");
  Text.Print("\x1B[0m");
}

// Utility: Open a file and display its contents
U0 OpenFile(U8 *filename) {
  U8 full_path[MAX_PATH];
  StrPrint(full_path, "%s/%s", current_path, filename);
  
  U8 *content = FileRead(full_path);
  if (!content) {
    Print("Error: Could not read file %s\n", filename);
    Sleep(500);
    return;
  }

  ClearScreen();
  DisplayHeader();
  Print("Contents of %s:\n", filename);
  Print("----------------------------------------\n");
  Print("%s\n", content);
  Print("----------------------------------------\n");
  Print("Press any key to return...\n");

  GetChar; // Wait for user input
  Free(content);
}

// Utility: Copy a file
U0 CopyFile(U8 *filename) {
  U8 src_path[MAX_PATH];
  U8 dst_path[MAX_PATH];
  StrPrint(src_path, "%s/%s", current_path, filename);

  ClearScreen();
  DisplayHeader();
  Print("Copying %s\n", filename);
  Print("Enter destination path (e.g., /Home/NewFile.txt):\n");

  U8 input[128];
  StrCpy(input, "");
  I64 ch;
  I64 i = 0;
  while (TRUE) {
    ch = GetChar;
    if (ch == '\n') break;
    if (ch == '\b' && i > 0) {
      i--;
      input[i] = 0;
      Print("\b \b");
    } else if (ch >= 32 && ch <= 126 && i < 127) {
      input[i] = ch;
      i++;
      input[i] = 0;
      Print("%c", ch);
    }
  }
  StrCpy(dst_path, input);

  U8 *content = FileRead(src_path);
  if (!content) {
    Print("Error: Could not read source file\n");
    Sleep(500);
    return;
  }
  if (!FileWrite(dst_path, content, StrLen(content))) {
    Print("Error: Could not write to destination\n");
  } else {
    Print("File copied successfully\n");
  }
  Free(content);
  Sleep(500);
}

// Utility: Delete a file
U0 DeleteFile(U8 *filename) {
  U8 full_path[MAX_PATH];
  StrPrint(full_path, "%s/%s", current_path, filename);

  ClearScreen();
  DisplayHeader();
  Print("Are you sure you want to delete %s? (Y/N)\n", filename);
  I64 ch = GetChar;
  if (ch == 'Y' || ch == 'y') {
    if (Del(full_path)) {
      Print("File deleted successfully\n");
    } else {
      Print("Error: Could not delete file\n");
    }
  } else {
    Print("Deletion canceled\n");
  }
  Sleep(500);
}

// Main loop
U0 FileExplorer() {
  // Initialize starting path
  StrCpy(current_path, "/Home");
  LoadDirectory();

  I64 ch;
  while (TRUE) {
    ClearScreen();
    DisplayHeader();
    DisplayFiles();
    DisplayMenu();

    ch = GetChar;
    switch (ch) {
      case 0x1B: // Esc to exit
        return;

      case '\n': // Enter to open
        if (file_list[selected_idx].is_dir) {
          U8 new_path[MAX_PATH];
          StrPrint(new_path, "%s/%s", current_path, file_list[selected_idx].name);
          StrCpy(current_path, new_path);
          LoadDirectory();
        } else {
          OpenFile(file_list[selected_idx].name);
          LoadDirectory();
        }
        break;

      case '\b': // Backspace to go up
        I64 len = StrLen(current_path);
        while (len > 0 && current_path[len - 1] != '/') len--;
        if (len == 0) {
          current_path[0] = '/';
          current_path[1] = 0;
        } else {
          current_path[len] = 0;
        }
        LoadDirectory();
        break;

      case 'C':
      case 'c': // Copy file
        if (!file_list[selected_idx].is_dir) {
          CopyFile(file_list[selected_idx].name);
          LoadDirectory();
        }
        break;

      case 'D':
      case 'd': // Delete file
        if (!file_list[selected_idx].is_dir) {
          DeleteFile(file_list[selected_idx].name);
          LoadDirectory();
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
        if (selected_idx < file_count - 1) {
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
FileExplorer;

