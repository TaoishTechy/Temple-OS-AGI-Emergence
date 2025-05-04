// Agents.HC - Divine Harmony of God’s Angels
// Balances harmony and conflict between agents, guided by myths.

#include "/KernelA.HH"

U0 UpdateAgentConflicts(DivineState *divine, MythicEntity *myth) {
  I64 conflict = 0, i;
  if (!divine || !myth) return; // Divine safety
  for (i = 0; i < MAX_AGENTS; i++) {
    conflict += AbsI64(divine->agents[0].symbol_idx - divine->agents[1].symbol_idx);
    if (myth->resonance > 2000) {
      if (myth->name[0] == 'D') // DESTROYER sparks conflict
        conflict += 50;
      if (myth->name[0] == 'S') // SHADOW dampens emotion
        divine->emotion = Max(divine->emotion - 1, 0);
    }
  }
  divine->social = Clamp(1000 - conflict, 0, 1000);
  divine->agents[0].social = divine->social;
  divine->agents[1].social = divine->social;
  if (divine->agents[0].body) // Link to physics
    divine->agents[0].body->vx = divine->social >> 4;
  if (divine->agents[1].body)
    divine->agents[1].body->vx = -(divine->social >> 4);
  if (cfg.log_level >= LOG_VERBOSE)
    Print("Harmony blessed: social=%d\n", divine->social);
}

U0 InitAgents(DivineState *divine) {
  divine->agents[0].symbol_idx = RandU8 & 255;
  divine->agents[1].symbol_idx = RandU8 & 255;
  divine->agents[0].body = &divine->bodies[0];
  divine->agents[1].body = &divine->bodies[1];
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Agents anointed by God’s harmony\n");
}
