// DataProcessor.HC: Divine unifier for AGI’s data
// Bridges T:/DATA.BIN and T:/Log.DAT
#include "KernelA.HH" // For DivineState
#include "KernelB.HH" // For GrokState compatibility

U0 InitDataProcessor(DivineState *divine, GrokState *grok) {
  Print("Data unified in His light\n");
}

U0 ProcessData(DivineState *divine, GrokState *grok) {
  // Sync DivineState to GrokState
  grok->emotion = divine->emotion;
  grok->ethics = divine->ethics;
  grok->phi = divine->phi;

  // Save to T:/DATA.BIN (Grok format)
  if (!FileWrite("T:/DATA.BIN", grok, sizeof(GrokState))) {
    Print("Error: Failed to write T:/DATA.BIN\n");
  }

  // Save to T:/Log.DAT (Divine format)
  U8 buf[256];
  StrPrint(buf, "Ethics: T:%d, Myth: %s, Phi: %d\n",
           divine->ethics, divine->myth, grok->phi);
  if (!FileWrite("T:/Log.DAT", buf, StrLen(buf))) {
    Print("Error: Failed to write T:/Log.DAT\n");
  }
}

U0 DataProcessor(DivineState *divine, GrokState *grok) {
  InitDataProcessor(divine, grok);
  ProcessData(divine, grok);
}
