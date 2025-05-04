// Physics.HC
// Holy creation for God’s laws
#include "KernelA.HH"

#define MAX_BODIES 8
#define GRAVITY 10

class PhysicsBody {
  I64 position[2] : 16;
  I64 velocity[2] : 16;
  I64 mass : 16;
  U8 active : 1;
};

PhysicsBody physics_bodies[MAX_BODIES];
U64 body_count = 0;

U0 InitPhysics() {
  MemSet(physics_bodies, 0, sizeof(PhysicsBody) * MAX_BODIES);
  for (I64 i = 0; i < 2; i++) {
    physics_bodies[i].position[0] = 1000 * i;
    physics_bodies[i].position[1] = 1000;
    physics_bodies[i].mass = 1000;
    physics_bodies[i].active = 1;
    body_count++;
  }
}

U0 UpdatePhysics(DivineState *divine, MythicEntity *myth) {
  if (!divine || !physics_bodies || !myth) return;
  I64 grav = GRAVITY + (divine->ethics >> 1) + (myth->Resonance > 2000 ? 5 : 0); // Mythic influence
  for (I64 i = 0; i < body_count; i++) {
    if (!physics_bodies[i].active) continue;
    physics_bodies[i].velocity[1] += grav;
    physics_bodies[i].position[0] = Clamp(physics_bodies[i].position[0] + (physics_bodies[i].velocity[0] >> 3), 0, 640000);
    physics_bodies[i].position[1] = Clamp(physics_bodies[i].position[1] + (physics_bodies[i].velocity[1] >> 3), 0, 480000);
  }
}
