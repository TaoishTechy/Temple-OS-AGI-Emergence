// TempleInput.HC - Simplified Input Processing for TempleOS AGI
#include "TempleHardware.HC"

// Basic command handler (expandable)
U0 HandleCommand(U8 *command) {
  Print("Command received: %s\n", command);
  // Add actual command logic here
}

// Process input with keyboard priority
U0 ProcessInput() {
  if (HasKeyboard()) {
    U8 *input = GetStr("Enter command: ");
    HandleCommand(input);
    Free(input);
  } else if (HasMouse() && MouseClick()) {
    HandleCommand("default_action");
  } else {
    Print("No input device detected. Please connect a keyboard or mouse.\n");
  }
}
