// TempleGratitude.HC - Simplified Gratitude System for TempleOS AGI
#include "TempleHardware.HC"
#include "TempleOutput.HC"

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

// Express gratitude with minimal checks
U0 ExpressGratitude() {
  if (HasKeyboard()) {
    U8 *gratitude = ReadInput("Offer gratitude: ");
    if (!gratitude) {
      Output("Error: Failed to allocate gratitude string.", TRUE, FALSE);
      return;
    }
    Output("Gratitude received.", TRUE, TRUE);
    Free(gratitude);
  } else if (HasMouse() && MouseClick()) {
    Output("Gratitude clicked.", TRUE, TRUE);
  } else {
    Output("No input device detected. Gratitude cannot be expressed.", TRUE, FALSE);
  }
}
