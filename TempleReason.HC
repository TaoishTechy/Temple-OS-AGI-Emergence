// TempleReason.HC - Reasoning Engine with Adaptive Input/Output
#include "TempleHardware.HC"
#include "TempleOutput.HC"

// Usage counters for learning
I64 reason_keyboard = 0;
I64 reason_mouse = 0;

// Apply reasoning adaptively
U0 ApplyReasoning() {
  if (!HasKeyboard() && !HasMouse()) {
    Output("No input device detected. Reasoning unavailable.", TRUE, FALSE);
    return;
  }
  if (HasKeyboard()) {
    U8 *logic = GetStr("Enter reasoning: ");
    Output("Reasoning applied.", TRUE, TRUE);
    reason_keyboard++;
    Free(logic);
  } else if (HasMouse() && MouseClick()) {
    Output("Mouse-based reasoning applied.", TRUE, TRUE);
    reason_mouse++;
  }
}

// Learn preferred reasoning method
U0 LearnReasoning() {
  if (reason_keyboard > reason_mouse) {
    Print("Keyboard preferred for reasoning.\n");
  } else if (reason_mouse > reason_keyboard) {
    Print("Mouse preferred for reasoning.\n");
  }
}
