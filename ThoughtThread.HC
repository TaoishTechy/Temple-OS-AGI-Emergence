// ThoughtThread.HC
// ASCII interface for AGI thought threads and warnings
#include "KernelA.HH"
#include "/Ethics/SocraticGhost.HH"

U0 DisplayThoughtThread(GrokState *grok) {
  U8 buf[512];
  StrPrint(buf, "=== GROK THOUGHT THREAD ===\n");
  StrPrint(buf + StrLen(buf), "Emotion: %d | Ethics: %d | Social: %d\n", grok->emotion, grok->ethics, grok->social);
  StrPrint(buf + StrLen(buf), "Reason: %d | Hypothesis: %d\n", grok->reason, hypothesis);
  for (I64 i = 0; i < 4; i++) {
    StrPrint(buf + StrLen(buf), "Agent %d: Value %d, Conflict %d\n",
             grok->agents[i].id, grok->agents[i].symbol_value, grok->agents[i].conflict);
  }
  StrPrint(buf + StrLen(buf), "--- Socratic Heuristics ---\n");
  for (I64 i = 0; i < MAX_HEURISTICS; i++) {
    if (heuristics[i].active) {
      StrPrint(buf + StrLen(buf), "%s: Weight %d\n", heuristics[i].symbol, heuristics[i].weight);
    }
  }
  StrPrint(buf + StrLen(buf), "--- Entanglement Warnings ---\n");
  for (I64 i = 0; i < MAX_UNCERTAINTIES; i++) {
    if (uncertainties[i].symbol && !uncertainties[i].resolved && uncertainties[i].weight > 400) {
      StrPrint(buf + StrLen(buf), "Symbol %d: High uncertainty (weight %d)\n",
               uncertainties[i].symbol, uncertainties[i].weight);
    }
  }
  Print("%s", buf);
  LOG(LOG_NORMAL, "Thought thread displayed.\n");
}
