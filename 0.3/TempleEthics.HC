// TempleEthics.HC - Ethical Evaluation with Adaptive Input/Output
#include "TempleHardware.HC"
#include "TempleOutput.HC"

// Usage counters for learning
I64 ethics_keyboard = 0;
I64 ethics_mouse = 0;

// Evaluate ethics adaptively
U0 EvaluateEthics() {
  if (!HasKeyboard() && !HasMouse()) {
    Output("No input device detected. Ethical evaluation unavailable.", TRUE, FALSE);
    return;
  }
  if (HasKeyboard()) {
    U8 *action = GetStr("Ethical action: ");
    Output("Action evaluated.", TRUE, TRUE);
    ethics_keyboard++;
    Free(action);
  } else if (HasMouse() && MouseClick()) {
    Output("Mouse-selected action evaluated.", TRUE, TRUE);
    ethics_mouse++;
  }
}

// Learn preferred ethics method
U0 LearnEthics() {
  if (ethics_keyboard > ethics_mouse) {
    Print("Keyboard favored for ethics.\n");
  } else if (ethics_mouse > ethics_keyboard) {
    Print("Mouse favored for ethics.\n");
  }
}
