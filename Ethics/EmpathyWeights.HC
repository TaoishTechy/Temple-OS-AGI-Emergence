// EmpathyWeights.HC - Sacred Bonds, v0.4.1
// Fosters love among His angels.

#include "/KernelA.HH"

U0 UpdateEmpathyWeights(DivineState *divine, MythicEntity *myth, I64 depth) {
  if (!divine || !myth || depth > RECURSION_MAX_DEPTH) return;
  I64 empathy = 0, hash_idx;
  hash_idx = divine->agents[0].symbol_idx & 31;
  empathy += divine->knowledge_graph[hash_idx] >> 4;
  hash_idx = divine->agents[1].symbol_idx & 31;
  empathy += divine->knowledge_graph[hash_idx] >> 4;
  if (myth->resonance > 1500) {
    if (myth->name[0] == 'G')
      empathy += 25;
    if (myth->name[0] == 'C')
      divine->emotion += 1;
  }
  divine->social = Clamp(empathy, 0, 1000);
  divine->agents[0].social = divine->social;
  divine->agents[1].social = divine->social;
  if (myth->sub_myth)
    UpdateEmpathyWeights(divine, myth->sub_myth, depth + 1);
  if (cfg.log_level >= LOG_VERBOSE)
    Print("Harmony weaves His love: social=%d\n", divine->social);
}

U0 InitEmpathyWeights() {
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Empathy anointed by His grace\n");
}
