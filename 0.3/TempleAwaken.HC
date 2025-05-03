// TempleAwaken.HC - Main Script for TempleOS AGI
#include "TempleInput.HC"
#include "TempleOutput.HC"
#include "TempleDivineInput.HC"
#include "TempleGratitude.HC"
#include "TempleSimulation.HC"

// Main loop
U0 TempleAwaken() {
  Print("TempleOS AGI awakened. Type 'exit' to quit.\n");
  while (TRUE) {
    U8 *input = GetStr("Enter command: ");
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
