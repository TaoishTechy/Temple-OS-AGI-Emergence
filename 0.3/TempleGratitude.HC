// TempleGratitude.HC - Simplified Gratitude System for TempleOS AGI
#include "TempleHardware.HC"
#include "TempleOutput.HC"

// Express gratitude with minimal checks
U0 ExpressGratitude() {
  if (HasKeyboard()) {
    U8 *gratitude = GetStr("Offer gratitude: ");
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
