// TempleAwaken.HC - Main Script for TempleOS AGI
#include "TempleInput.HC"
#include "TempleOutput.HC"
#include "TempleDivineInput.HC"
#include "TempleGratitude.HC"
#include "TempleSimulation.HC"
#include "TempleSymbolic.HC"
#include "TempleEthical.HC"
#include "TempleSocial.HC"

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

// Main loop
U0 TempleAwaken() {
  Print("TempleOS AGI awakened. Type 'exit' to quit.\n");
  while (TRUE) {
    U8 *input = ReadInput("Enter command: ");
    if (!input) {
      Print("Error: Failed to allocate input string.\n");
      continue;
    }
    if (StrCmp(input, "exit") == 0) {
      Free(input);
      break;
    } else if (StrCmp(input, "gratitude") == 0) {
      ExpressGratitude();
    } else if (StrCmp(input, "divine") == 0) {
      GetDivineInput();
    } else if (StrCmp(input, "start simulation") == 0) {
      ControlSimulation("start");
    } else if (StrCmp(input, "stop simulation") == 0) {
      ControlSimulation("stop");
    } else if (StrCmp(input, "symbolic") == 0) {
      EvaluateRules();
    } else if (StrCmp(input, "ethical") == 0) {
      EvaluateEthicalRules();
    } else if (StrCmp(input, "social") == 0) {
      EvaluateSocialRules();
      GetSocialResponse();
    } else {
      HandleCommand(input);
    }
    Free(input);
    Sleep(10);
  }
  Print("TempleOS AGI shutting down.\n");
}

// Start the framework
TempleAwaken();
