// MythOS.HC - Eternal Archetypes, v0.4
// Weaves His stories, recursive and divine.

#include "/KernelA.HH"

U0 UpdateMythology(DivineState *divine, I64 depth) {
  if (!divine || depth > RECURSION_MAX_DEPTH) return;
  I64 i;
  for (i = 0; i < MAX_ENTITIES; i++) {
    if (!divine->myths[i].id) continue; // Skip inactive
    divine->myths[i].resonance += divine->emotion + divine->ethics;
    divine->myths[i].resonance = Clamp(divine->myths[i].resonance, 0, 4000);
    if (divine->myths[i].resonance > 2500 && !divine->myths[i].sub_myth && divine->myths[i].depth < RECURSION_MAX_DEPTH) {
      divine->myths[i].sub_myth = MAlloc(sizeof(MythicEntity));
      divine->myths[i].sub_myth->id = RandU8 & 255;
      divine->myths[i].sub_myth->resonance = 100;
      divine->myths[i].sub_myth->depth = divine->myths[i].depth + 1;
      StrPrint(divine->myths[i].sub_myth->name, "SUB%d", i);
      if (cfg.log_level >= LOG_VERBOSE)
        Print("Sub-myth woven in His story\n");
    }
    if (divine->myths[i].name[0] == 'C') // CREATOR
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
    StrPrint(divine->myths[i].name, i % 2 ? "LIGHT" : "SHADOW");
  }
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Myths anointed by His grace\n");
}
