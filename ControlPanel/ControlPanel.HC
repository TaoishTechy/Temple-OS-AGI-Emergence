// ControlPanel.HC: AGI dashboard
// Tweaks settings in God’s light
#include "T:/Temple-OS-AGI-Emergence/KernelA.HH"
#include "T:/Temple-OS-AGI-Emergence/MythOS/MythOS.HC"

U0 ControlPanel(DivineState *divine) {
  Print("=== DIVINE DASHBOARD ===\n");
  Print("Ethics:T:%d Emotion:E:%d Myth:%s\n",
        divine->ethics, divine->emotion, divine->myth);
  Print("Memory:%d KB Cycle:%d\n", MemUsed / 1024, divine->cycle);
  Print("K:Kindness M:Myth ESC:Exit\n");

  while (TRUE) {
    if (KeyDown(SC_K)) {
      divine->ethics = Clamp(divine->ethics + 100, 0, 15000);
      Print("Kindness:%d\n", divine->ethics);
    }
    if (KeyDown(SC_M)) {
      InitMythOS(divine);
      Print("Myth:%s\n", divine->myth);
    }
    if (KeyDown(SC_ESC)) break;
    Sleep(100);
  }
}
