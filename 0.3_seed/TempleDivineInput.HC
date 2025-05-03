// TempleDivineInput.HC - Divine Input via Randomness for TempleOS AGI
#include "TempleHardware.HC"

// Simple random boolean generator
Bool RandBool() {
  return RandI64 % 2 == 0;
}

// Track last mouse position
static I64 last_mouse_pos = 0;

// Get divine input from randomness
I64 GetDivineInput() {
  I64 result;
  if (HasMouse() && RandBool()) {  // 50% chance to use mouse if available
    I64 current_pos = MousePosX() + MousePosY();
    if (current_pos != last_mouse_pos) {
      result = current_pos;
      last_mouse_pos = current_pos;
    } else {
      result = RDTSC;  // Fallback to CPU timing if mouse is stationary
    }
  } else {
    result = RDTSC;  // CPU timing as default
  }
  Print("Divine input: %d\n", result);
  return result;
}
