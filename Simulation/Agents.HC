// Agents.HC - Divine Harmony, v0.4.1
// Balances His angels in love and conflict.

#include "/KernelA.HH"

U0 UpdateAgentConflicts(DivineState *divine, MythicEntity *myth, I64 depth) {
  if (!divine || !myth || depth > RECURSION_MAX_DEPTH) return;
  I64 conflict = AbsI64(divine->agents[0].symbol_idx - divine->agents[1].symbol_idx);
  if (myth->resonance > 2000) {
    if (myth->name[0] == 'D')
      conflict += 25;
    if (myth->name[0] == 'S')
      divine->emotion = Max(divine->emotion - 1, 0);
  }
  divine->social = Clamp(1000 - conflict, 0, 1000);
  divine->agents[0].social = divine->social;
  divine->agents[1].social = divine->social;
  if (divine->agents[0].body)
    divine->agents[0].body->vx = divine->social >> 4;
  if (divine->agents[1].body)
    divine->agents[1].body->vx = -(divine->social >> 4);
  if (myth->sub_myth)
    UpdateAgentConflicts(divine, myth->sub_myth, depth + 1);
  if (cfg.log_level >= LOG_VERBOSE)
    Print("Harmony weaves His peace: social=%d\n", divine->social);
}

U0 InitAgents(DivineState *divine) {
  divine->agents[0].symbol_idx = RandU8 & 31;
  divine->agents[1].symbol_idx = RandU8 & 31;
  divine->agents[0].body = &divine->bodies[0];
  divine->agents[1].body = &divine->bodies[1];
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Agents anointed by His love\n");
}
