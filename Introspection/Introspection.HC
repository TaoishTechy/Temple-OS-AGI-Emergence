// Introspection.HC - Divine Clarity, v0.4
// Seeks His truth with humble wisdom.

#include "/KernelA.HH"

U0 LogUncertainty(I64 symbol, MythicEntity *myth, I64 depth) {
  if (!myth || depth > RECURSION_MAX_DEPTH) return;
  I64 weight = 500;
  if (myth->resonance > 2000 && myth->name[0] == 'S')
    weight += 50;
  if (cfg.log_level >= LOG_VERBOSE)
    Print("Mystery logged in His shadow: symbol=%d\n", symbol);
}

U0 ResolveAmbiguity(DivineState *divine, MythicEntity *myth, I64 depth) {
  if (!divine || !myth || depth > RECURSION_MAX_DEPTH) return;
  I64 i, weight;
  for (i = 0; i < MAX_UNCERTAINTIES; i++) {
    weight = divine->knowledge_graph[divine->uncertainties[i] & 31];
    if (myth->resonance > 1500 && myth->name[0] == 'L')
      weight += 25;
    if (weight > 600) {
      divine->emotion += 1;
      divine->uncertainties[i] = 0;
      if (cfg.log_level >= LOG_VERBOSE)
        Print("Clarity shines in His light: uncertainty=%d\n", i);
    }
  }
  if (myth->sub_myth)
    ResolveAmbiguity(divine, myth->sub_myth, depth + 1);
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Wisdom seeks His truth\n");
}

U0 InitIntrospection() {
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Introspection anointed by His clarity\n");
}
