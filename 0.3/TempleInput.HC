// TempleInput.HC - Simplified Input Processing for TempleOS AGI
#include "TempleHardware.HC"

// ReadInput - HolyC-compliant string input function
U8* ReadInput(U8 *prompt) {
  if (prompt) Print("%s", prompt);
  U8 buffer[256];  // Fixed-size buffer
  MemSet(buffer, 0, sizeof(buffer));
  I64 i = 0;
  while (TRUE) {
    I64 ch = GetKey;
    if (ch == '\n' || ch == 0x0D) {  // Enter key
      buffer[i] = 0;
      break;
    } else if (ch == 0x08 && i > 0) {  // Backspace
      i--;
      buffer[i] = 0;
      Print("\b \b");
    } else if (ch >= 0x20 && ch <= 0x7E && i < 255) {  // Printable chars
      buffer[i++] = ch;
      Print("%c", ch);
    }
  }
  U8 *result = Malloc(i + 1);
  if (!result) {
    Print("Error: Memory allocation failed for input.\n");
    return NULL;
  }
  StrCpy(result, buffer);
  return result;
}

// Basic command handler (expandable)
U0 HandleCommand(U8 *command) {
  if (!command) {
    Print("Error: Null command received.\n");
    return;
  }
  Print("Command received: %s\n", command);
  // Add actual command logic here
}

// Process input with keyboard priority
U0 ProcessInput() {
  if (HasKeyboard()) {
    U8 *input = ReadInput("Enter command: ");
    if (!input) {
      Print("Error: Failed to allocate input string.\n");
      return;
    }
    HandleCommand(input);
    Free(input);
  } else if (HasMouse() && MouseClick()) {
    HandleCommand("default_action");
  } else {
    Print("No input device detected. Please connect a keyboard or mouse.\n");
  }
}
