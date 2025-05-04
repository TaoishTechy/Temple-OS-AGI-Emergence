// TempleVision.HC - Visualization System for TempleOS AGI
// Built for God's glory, as Terry A. Davis envisioned
#include "KernelA.HH"
#include "KernelB.HH"

// Constants for Visualization
#define BAR_WIDTH 20
#define BAR_HEIGHT 10
#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 480

// Function to Draw a Bar Representing a Metric
U0 DrawBar(I64 x, I64 y, I64 value, I64 max, U32 color) {
  I64 bar_length = (value * BAR_WIDTH) / max;
  if (bar_length > BAR_WIDTH) bar_length = BAR_WIDTH;
  if (bar_length < 0) bar_length = 0;
  GrFillRect(x, y, bar_length, BAR_HEIGHT, color);
  GrRect(x, y, BAR_WIDTH, BAR_HEIGHT, WHITE); // Outline
}

// Main Visualization Function
U0 VisionUpdate() {
  if (!temple.awake) {
    Print("$$RED$$System not awake. No vision to display.$$FG,0$$\n");
    return;
  }

  // Clear Screen
  GrClear(BLACK);

  // Title
  GrPrint(SCREEN_WIDTH / 2 - 50, 10, "$$GREEN$$Temple Dashboard$$FG,0$$");

  // Faith Metric
  GrPrint(10, 50, "Faith: %d/10", temple.faith);
  DrawBar(100, 50, temple.faith, 10, GREEN);

  // Coherence Metric
  GrPrint(10, 70, "Coherence: %d/100", temple.coherence);
  DrawBar(100, 70, temple.coherence, 100, BLUE);

  // Phi Metric
  GrPrint(10, 90, "Phi: %d/100", temple.phi);
  DrawBar(100, 90, temple.phi, 100, YELLOW);

  // Status Message
  if (temple.faith >= 5) {
    GrPrint(10, 120, "$$GREEN$$The Temple shines with faith.$$FG,0$$");
  } else if (temple.faith >= 3) {
    GrPrint(10, 120, "$$YELLOW$$Seek more prayer.$$FG,0$$");
  } else {
    GrPrint(10, 120, "$$RED$$Faith is low. Repent.$$FG,0$$");
  }

  // Refresh Display
  GrUpdate();
  Sleep(100); // Brief pause to view
}
