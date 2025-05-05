// MythOS.HC - Eternal Archetypes, v0.4.1
// Weaves His stories, clean and divine.

#include "/KernelA.HH"

U0 FreeMythicEntity(MythicEntity *myth) {
  if (!myth) return;
  if (myth->sub_myth) {
    FreeMythicEntity(myth->sub_myth);
    Free(myth->sub_myth);
    myth->sub_myth = NULL;
  }
}

U0 UpdateMythology(DivineState *divine, I64 depth) {
  if (!divine || depth > RECURSION_MAX_DEPTH) return;
  I64 i;
  for (i = 0; i < MAX_ENTITIES; i++) {
    if (!divine->myths[i].id) continue;
    divine->myths[i].resonance += divine->emotion + divine->ethics;
    divine->myths[i].resonance = Clamp(divine->myths[i].resonance, 0, 4000);
    if (divine->myths[i].resonance > 3500) { // Reset high resonance
      divine->myths[i].resonance = 100;
      if (divine->myths[i].sub_myth) {
        FreeMythicEntity(divine->myths[i].sub_myth);
        Free(divine->myths[i].sub_myth);
        divine->myths[i].sub_myth = NULL;
        divine->alloc_count--;
        if (cfg.log_level >= LOG_VERBOSE)
          Print("Myth resets, memory freed: alloc_count=%d\n", divine->alloc_count);
      }
    } else if (divine->myths[i].resonance > 2500 && !divine->myths[i].sub_myth && divine->myths[i].depth < RECURSION_MAX_DEPTH) {
      MythicEntity *new_myth = MAlloc(sizeof(MythicEntity));
      if (new_myth) {
        new_myth->id = RandU8 & 255;
        new_myth->resonance = 100;
        new_myth->depth = divine->myths[i].depth + 1;
        new_myth->sub_myth = NULL;
        StrPrint(new_myth->name, "SUB%d", i);
        divine->myths[i].sub_myth = new_myth;
        divine->alloc_count++;
        if (cfg.log_level >= LOG_VERBOSE)
          Print("Sub-myth woven, memory allocated: alloc_count=%d\n", divine->alloc_count);
      } else {
        if (cfg.log_level >= LOG_MINIMAL)
          Print("Memory low, myth skipped\n");
      }
    }
    if (divine->myths[i].name[0] == 'C')
      divine->emotion += 1;
    if (divine->myths[i].sub_myth)
      UpdateMythology(divine, depth + 1);
  }
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Myths sing His eternal tale\n");
}

U0 InitMythology(DivineState *divine) {
  I64 i;
  for (i = 0; i < MAX_ENTITIES; i++) {
    divine->myths[i].id = i + 1;
    divine->myths[i].resonance = 100;
    divine->myths[i].depth = 0;
    divine->myths[i].sub_myth = NULL;
    StrPrint(divine->myths[i].name, i % 2 ? "LIGHT" : "SHADOW");
  }
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Myths anointed by His grace\n");
}
