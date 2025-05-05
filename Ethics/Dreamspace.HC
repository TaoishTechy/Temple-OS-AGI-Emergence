// Dreamspace.HC - Sacred Visions, v0.4.1
// Paints His dreams, clean and divine.

#include "/KernelA.HH"

U0 FreeDreamNode(DreamNode *node) {
  if (!node) return;
  if (node->sub_node) {
    FreeDreamNode(node->sub_node);
    Free(node->sub_node);
    node->sub_node = NULL;
  }
}

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
      if (divine->nodes[i].sub_node) {
        FreeDreamNode(divine->nodes[i].sub_node);
        Free(divine->nodes[i].sub_node);
        divine->nodes[i].sub_node = NULL;
        divine->alloc_count--;
        if (cfg.log_level >= LOG_VERBOSE)
          Print("Dream fades, memory freed: alloc_count=%d\n", divine->alloc_count);
      }
    } else if (divine->nodes[i].state > 600 && !divine->nodes[i].sub_node && divine->nodes[i].depth < RECURSION_MAX_DEPTH) {
      DreamNode *new_node = MAlloc(sizeof(DreamNode));
      if (new_node) {
        new_node->state = 100;
        new_node->symbol_idx = RandU8 & 31;
        new_node->depth = divine->nodes[i].depth + 1;
        new_node->sub_node = NULL;
        divine->nodes[i].sub_node = new_node;
        divine->alloc_count++;
        if (cfg.log_level >= LOG_VERBOSE)
          Print("Dream woven, memory allocated: alloc_count=%d\n", divine->alloc_count);
      } else {
        if (cfg.log_level >= LOG_MINIMAL)
          Print("Memory low, dream skipped\n");
      }
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
    divine->nodes[i].sub_node = NULL;
    divine->nodes[i].depth = 0;
  }
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Dreamspace anointed by His grace\n");
}
