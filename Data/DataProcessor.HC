// DataProcessor.HC: Unifies AGI’s data
// Syncs T:/DATA.BIN and T:/Log.DAT
#include "T:/Temple-OS-AGI-Emergence/KernelA.HH"
#include "T:/Temple-OS-AGI-Emergence/Grok/Scripts/KernelB.HH"

U0 InitDataProcessor(DivineState *divine, GrokState *grok) {
  divine->cycle = grok->cycle;
  if (cfg == LOG_VERBOSE) {
    Print("Data unified\n");
  }
}

U0 ProcessData(DivineState *divine, GrokState *grok) {
  grok->emotion = divine->emotion;
  grok->ethics = divine->ethics;
  grok->phi = divine->phi;
  StrCpy(grok->myth, divine->myth);

  if (!FileWrite("T:/DATA.BIN", grok, sizeof(GrokState))) {
    Print("Error: Write T:/DATA.BIN failed\n");
    return;
  }
  U8 buf[256];
  StrPrint(buf, "Cycle:%d Ethics:T:%d Myth:%s Phi:%d\n",
           divine->cycle, divine->ethics, divine->myth, grok->phi);
  if (!FileWrite("T:/Log.DAT", buf, StrLen(buf))) {
    Print("Error: Write T:/Log.DAT failed\n");
    return;
  }
  if (cfg == LOG_VERBOSE) {
    Print("Unified: %s", buf);
  }
}

U0 DataProcessor(DivineState *divine, GrokState *grok) {
  InitDataProcessor(divine, grok);
  ProcessData(divine, grok);
}

