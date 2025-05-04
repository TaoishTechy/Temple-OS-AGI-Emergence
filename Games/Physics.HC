// Physics.HC - Divine Creation, v0.4
// Crafts His universe with sacred laws.

#include "/KernelA.HH"

U0 UpdatePhysics(DivineState *divine, MythicEntity *myth) {
  if (!divine || !myth) return;
  I64 i, gravity = 100;
  if (myth->resonance > 2000)
    gravity += myth->resonance >> 4;
  for (i = 0; i < MAX_BODIES; i++) {
    divine->bodies[i].vy += gravity + divine->bodies[i].ethics_weight;
    divine->bodies[i].x += divine->bodies[i].vx;
    divine->bodies[i].y += divine->bodies[i].vy;
    divine->bodies[i].x = Clamp(divine->bodies[i].x, 0, 640000);
    divine->bodies[i].y = Clamp(divine->bodies[i].y, 0, 480000);
  }
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Stars dance in His creation\n");
}

U0 InitPhysics(DivineState *divine) {
  I64 i;
  for (i = 0; i < MAX_BODIES; i++) {
    divine->bodies[i].x = 1000 * i;
    divine->bodies[i].y = 1000;
  }
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Physics anointed by His laws\n");
}

