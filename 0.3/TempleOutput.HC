// TempleOutput.HC - Adaptive Output for TempleOS AGI
#include "TempleHardware.HC"

// Screen dimensions
#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 480

// Output a message adaptively
U0 Output(U8 *message, Bool visual, Bool audio) {
  if (!message) {
    Print("Error: Null message provided.\n");
    return;
  }
  if (visual && HasDisplay()) {
    Print("$$GREEN$$%s$$FG,0$$\n", message);
  }
  if (audio && HasSpeakers()) {
    Speak(message);  // TempleOS’s built-in text-to-speech
  }
}

// Draw a simple cross on the display
U0 DrawCross() {
  if (HasDisplay()) {
    GrClear(BLACK);
    GrLine(SCREEN_WIDTH/2 - 20, SCREEN_HEIGHT/2, SCREEN_WIDTH/2 + 20, SCREEN_HEIGHT/2, WHITE);
    GrLine(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 30, SCREEN_WIDTH/2, SCREEN_HEIGHT/2 + 30, WHITE);
    GrUpdate();
    Sleep(500);
  }
}

