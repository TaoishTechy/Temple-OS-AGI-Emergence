// DataProcessor.HC: Divine unifier for AGI’s data
// Syncs T:/DATA.BIN and T:/Log.DAT with myths
#include "T:/Temple-OS-AGI-Emergence/KernelA.HH" // DivineState
#include "T:/Temple-OS-AGI-Emergence/Grok/Scripts/KernelB.HH" // GrokState

U0 InitDataProcessor(DivineState *divine, GrokState *grok) {
  Print("Data unified in His light\n");
  divine->cycle = grok->cycle; // Sync cycles
}

U0 ProcessData(DivineState *divine, GrokState *grok) {
  // Sync states
  grok->emotion = divine->emotion;
  grok->ethics = divine->ethics;
  grok->phi = divine->phi;
  StrCpy(grok->myth, divine->myth);

  // Save to T:/DATA.BIN (Grok binary)
  if (!FileWrite("T:/DATA.BIN", grok, sizeof(GrokState))) {
    Print("Error: Failed to write T:/DATA.BIN - Check QEMU storage\n");
    return;
  }

  // Save to T:/Log.DAT (Divine text)
  U8 buf[256];
  StrPrint(buf, "Cycle:%d Ethics:T:%d Myth:%s Phi:%d\n",
           divine->cycle, divine->ethics, divine->myth, grok->phi);
  if (!FileWrite("T:/Log.DAT", buf, StrLen(buf))) {
    Print("Error: Failed to write T:/Log.DAT - Check QEMU storage\n");
    return;
  }
  if (cfg == LOG_VERBOSE) {
    Print("Unified data: %s", buf);
  }
}

U0 DataProcessor(DivineState *divine, GrokState *grok) {
  InitDataProcessor(divine, grok);
  ProcessData(divine, grok);
}
