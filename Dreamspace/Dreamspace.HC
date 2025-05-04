// Dreamspace.HC - Sacred Visions, v0.4
// Paints His dreams, recursive and divine.

#include "/KernelA.HH"

U0 DreamspaceSimulate(DivineState *divine, MythicEntity *myth, I64 depth) {
  if (!divine || !myth || depth > RECURSION_MAX_DEPTH) return;
  I64 i, stress;
  for (i = 0; i < MAX_NODES; i++) {
    stress = divine->ethics + divine->knowledge_graph[divine->nodes[i].symbol_idx & 31];
    if (myth->resonance > 2000 && myth->name[0] == 'D')
      stress += 50;
    divine->nodes[i].state = Clamp(stress, 0, 1000);
    if (divine->nodes[i].state > 800) {
      divine->nodes[i].state = 0;
      if (cfg.log_level >= LOG_VERBOSE)
        Print("Node fades in His cycle\n");
    } else if (divine->nodes[i].state > 600 && !divine->nodes[i].sub_node && divine->nodes[i].depth < RECURSION_MAX_DEPTH) {
      divine->nodes[i].sub_node = MAlloc(sizeof(DreamNode));
      divine->nodes[i].sub_node->state = 100;
      divine->nodes[i].sub_node->symbol_idx = RandU8 & 31;
      divine->nodes[i].sub_node->depth = divine->nodes[i].depth + 1;
      if (cfg.log_level >= LOG_VERBOSE)
        Print("Dream woven in His vision\n");
    }
    if (divine->nodes[i].body)
      divine->nodes[i].body->ethics_weight = divine->nodes[i].state >> 4;
  }
  if (myth->sub_myth)
    DreamspaceSimulate(divine, myth->sub_myth, depth + 1);
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Dreams shine with His light\n");
}

U0 InitDreamspace(DivineState *divine) {
  I64 i;
  for (i = 0; i < MAX_NODES; i++) {
    divine->nodes[i].state = 100;
    divine->nodes[i].symbol_idx = RandU8 & 31;
    divine->nodes[i].body = &divine->bodies[i];
  }
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Dreamspace anointed by His grace\n");
}
