// Physics.HC
// Holy physics engine for God’s creation
#include "KernelA.HH"

#define MAX_BODIES 16
#define GRAVITY 10

class PhysicsBody {
  I64 position[2];
  I64 velocity[2];
  I64 mass;
  I64 size[2];
  U8 active : 1;
};

PhysicsBody physics_bodies[MAX_BODIES];
U64 body_count = 0;

U0 InitPhysics() {
  MemSet(physics_bodies, 0, sizeof(PhysicsBody) * MAX_BODIES);
  for (I64 i = 0; i < 4; i++) {
    physics_bodies[i].position[0] = 1000 * i;
    physics_bodies[i].position[1] = 1000;
    physics_bodies[i].mass = 1000;
    physics_bodies[i].size[0] = 500;
    physics_bodies[i].size[1] = 500;
    physics_bodies[i].active = 1;
    body_count++;
  }
  LOG(LOG_NORMAL, "Physics blessed for God’s creation.\n");
}

U0 UpdatePhysics(DivineState *divine) {
  if (!divine || !physics_bodies) {
    LOG(LOG_NORMAL, "Error: Physics lacks divine state or bodies.\n");
    return;
  }
  I64 gravity = GRAVITY + (divine->ethics >> 1);
  for (I64 i = 0; i < body_count; i++) {
    if (!physics_bodies[i].active) continue;
    physics_bodies[i].velocity[1] += gravity;
    physics_bodies[i].position[0] += physics_bodies[i].velocity[0] >> 3;
    physics_bodies[i].position[1] += physics_bodies[i].velocity[1] >> 3;
    physics_bodies[i].position[0] = Clamp(physics_bodies[i].position[0], 0, 640000);
    physics_bodies[i].position[1] = Clamp(physics_bodies[i].position[1], 0, 480000);
  }
  for (I64 i = 0; i < body_count; i++) {
    if (!physics_bodies[i].active) continue;
    for (I64 j = i + 1; j < body_count; j++) {
      if (!physics_bodies[j].active) continue;
      I64 dx = Abs(physics_bodies[i].position[0] - physics_bodies[j].position[0]);
      I64 dy = Abs(physics_bodies[i].position[1] - physics_bodies[j].position[1]);
      I64 sx = physics_bodies[i].size[0] + physics_bodies[j].size[0];
      I64 sy = physics_bodies[i].size[1] + physics_bodies[j].size[1];
      if (dx < sx && dy < sy) {
        physics_bodies[i].velocity[0] = -physics_bodies[i].velocity[0] >> 1;
        physics_bodies[j].velocity[0] = -physics_bodies[j].velocity[0] >> 1;
        LOG(LOG_VERBOSE, "Collision in God’s creation: Body %d vs %d\n", i, j);
      }
    }
  }
}
