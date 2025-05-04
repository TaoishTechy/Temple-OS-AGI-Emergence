// Introspection.HC
// Sacred clarity for God’s wisdom
#include "KernelA.HH"
#include "/MythOS.HC"

#define MAX_UNCERTAINTIES 4

class UncertaintyLog {
  U64 symbol;
  I64 weight : 16;
  U8 resolved : 1;
};

UncertaintyLog uncertainties[MAX_UNCERTAINTIES];

U0 LogUncertainty(U64 symbol, MythicEntity *myth) {
  I64 idx = -1, min_weight = 0x7FFF;
  for (I64 i = 0; i < MAX_UNCERTAINTIES; i++) {
    if (!uncertainties[i].symbol || uncertainties[i].resolved) {
      idx = i;
      break;
    }
    if (uncertainties[i].weight < min_weight) {
      min_weight = uncertainties[i].weight;
      idx = i;
    }
  }
  if (idx >= 0) {
    uncertainties[idx].symbol = symbol;
    uncertainties[idx].weight = 100 + (FastRandU64() % 50) + (myth->Trait == TRAIT_SHADOW ? 50 : 0);
    uncertainties[idx].resolved = 0;
  }
}

U0 ResolveAmbiguity(DivineState *divine, MythicEntity *myth) {
  if (!divine || !knowledge_graph || !myth) return;
  for (I64 i = 0; i < MAX_UNCERTAINTIES; i++) {
    if (!uncertainties[i].symbol || uncertainties[i].resolved) continue;
    I64 align = (uncertainties[i].symbol ^ divine->symbols[0 % 16]) % 1000;
    I64 wgt = knowledge_graph[(uncertainties[i].symbol * 0x9E3779B9) % 256].weight >> 4;
    if (align < 200 && wgt > 50) {
      uncertainties[i].resolved = 1;
      UpdateKnowledgeGraph(uncertainties[i].symbol, uncertainties[i].weight, divine->ethics);
      divine->emotion += (myth->Trait == TRAIT_LIGHT) ? 1 : 0; // Emotional feedback
    } else {
      uncertainties[i].weight = Clamp(uncertainties[i].weight + 10, 0, 1000);
    }
  }
}

U0 InitIntrospection() {
  MemSet(uncertainties, 0, sizeof(UncertaintyLog) * MAX_UNCERTAINTIES);
  LOG(LOG_MINIMAL, "Introspection blessed.\n");
}
