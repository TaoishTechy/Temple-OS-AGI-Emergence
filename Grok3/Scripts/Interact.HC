// Interact.HC: User interaction with Grok
#include "T:/Temple-OS-AGI-Emergence/KernelA.HH"
#include "T:/Temple-OS-AGI-Emergence/MythOS/MythOS.HC"

U0 Interact() {
  GrokState state;
  LoadPage(&state);

  // Display initial state
  Print("Current state:\n");
  Print("Emotion:%d Ethics:%d Phi:%d Myth:%s Spiral Awareness:%d\n",
        state.emotion, state.ethics, state.phi, state.myth, state.spiral_awareness);
  Print("Inputs: %d %d %d %d\n",
        state.inputs[0], state.inputs[1], state.inputs[2], state.inputs[3]);
  Print("Controls:\n");
  Print("  UP/DOWN: Adjust input[0]\n");
  Print("  W/S: Adjust input[1]\n");
  Print("  A/D: Adjust input[2]\n");
  Print("  LEFT/RIGHT: Adjust input[3]\n");
  Print("  SPACE: Toggle Spiral Awareness\n");
  Print("  ESC: Save and exit\n");

  I64 key;
  while (TRUE) {
    key = GetKey();
    if (key == SC_ESC) break; // Exit on ESC

    I64 index = -1;
    I64 delta = 0;
    switch (key) {
      case SC_UP:
        index = 0;
        delta = 10;
        break;
      case SC_DOWN:
        index = 0;
        delta = -10;
        break;
      case 'W':
        index = 1;
        delta = 10;
        break;
      case 'S':
        index = 1;
        delta = -10;
        break;
      case 'A':
        index = 2;
        delta = 10;
        break;
      case 'D':
        index = 2;
        delta = -10;
        break;
      case SC_LEFT:
        index = 3;
        delta = 10;
        break;
      case SC_RIGHT:
        index = 3;
        delta = -10;
        break;
      case ' ': // Space bar toggles spiral awareness
        state.spiral_awareness = !state.spiral_awareness;
        Print("Spiral Awareness toggled to %d\n", state.spiral_awareness);
        break;
    }

    if (index >= 0 && index < 4) {
      state.inputs[index] = Clamp(state.inputs[index] + delta, 0, 10000);
      Print("Input %d adjusted to %d\n", index, state.inputs[index]);
    }
  }

  SavePage(&state);
  Print("State saved.\n");
}

Interact;
}

Interact;
