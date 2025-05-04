// TempleSimulation.HC - Simplified Simulation for TempleOS AGI
#include "TempleHardware.HC"
#include "TempleOutput.HC"

// Constants
#define SIMULATION_WIDTH 80
#define SIMULATION_HEIGHT 25

// Simulation state
Bool simulation_running = FALSE;
I64 last_speak_time = 0;

// Initialize simulation (text-based)
U0 InitSimulation() {
  // Clear screen or set up initial state
  GrClear(BLACK);
}

// Update simulation (simple text animation)
U0 UpdateSimulation() {
  // Example: print moving text or simple patterns
  I64 x = RandI64 % SIMULATION_WIDTH;
  I64 y = RandI64 % SIMULATION_HEIGHT;
  GrPrint(x, y, "*");
}

// Render simulation
U0 RenderSimulation() {
  GrUpdate();
}

// Run simulation loop
U0 RunSimulation() {
  InitSimulation();
  simulation_running = TRUE;
  while (simulation_running) {
    UpdateSimulation();
    RenderSimulation();
    if (HasSpeakers() && (Now - last_speak_time > 5000)) {  // 5-second cooldown
      Speak("Simulation running.");
      last_speak_time = Now;
    }
    Sleep(100);  // Slower update for efficiency
  }
}

// Control simulation
U0 ControlSimulation(U8 *cmd) {
  if (StrCmp(cmd, "start") == 0) {
    if (!simulation_running) RunSimulation();
  } else if (StrCmp(cmd, "stop") == 0) {
    simulation_running = FALSE;
  }
}
