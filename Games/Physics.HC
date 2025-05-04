// Physics.HC - Simple Physics Module for TempleOS
#include "KernelA.HH"

#define GRAVITY 9.8 // Scaled for game (pixels per frame^2)
#define MAX_OBJECTS 32 // Max structural components
#define COLLISION_THRESHOLD 0.1 // Minimum overlap for collision

// 3D Vector
class Vector3 {
  F64 x, y, z;
};

// Physics Object
class PhysicsObject {
  Vector3 pos; // Position in 3D space
  Vector3 vel; // Velocity
  F64 mass; // Mass in arbitrary units
  Vector3 size; // Bounding box (width, height, depth)
  U8 active : 1; // Active flag
};

// Global Physics State
PhysicsObject objects[MAX_OBJECTS];
I64 object_count = 0;

// Initialize Physics
U0 PhysicsInit() {
  MemSet(objects, 0, sizeof(PhysicsObject) * MAX_OBJECTS);
  object_count = 0;
}

// Add Object
I64 PhysicsAddObject(F64 x, F64 y, F64 z, F64 mass, F64 width, F64 height, F64 depth) {
  if (object_count >= MAX_OBJECTS) return -1;
  I64 idx = object_count++;
  objects[idx].pos.x = x;
  objects[idx].pos.y = y;
  objects[idx].pos.z = z;
  objects[idx].vel.x = 0;
  objects[idx].vel.y = 0;
  objects[idx].vel.z = 0;
  objects[idx].mass = mass;
  objects[idx].size.x = width;
  objects[idx].size.y = height;
  objects[idx].size.z = depth;
  objects[idx].active = 1;
  return idx;
}

// Update Physics (Gravity and Velocity)
U0 PhysicsUpdate(F64 delta_time) {
  for (I64 i = 0; i < object_count; i++) {
    if (!objects[i].active) continue;
    // Apply gravity (y-axis downward)
    objects[i].vel.y -= objects[i].mass * GRAVITY * delta_time;
    // Update position
    objects[i].pos.x += objects[i].vel.x * delta_time;
    objects[i].pos.y += objects[i].vel.y * delta_time;
    objects[i].pos.z += objects[i].vel.z * delta_time;
    // Ground collision (y=0)
    if (objects[i].pos.y < objects[i].size.y / 2) {
      objects[i].pos.y = objects[i].size.y / 2;
      objects[i].vel.y = 0;
    }
  }
}

// Collision Detection (Axis-Aligned Bounding Box)
U0 PhysicsCheckCollisions() {
  for (I64 i = 0; i < object_count; i++) {
    if (!objects[i].active) continue;
    for (I64 j = i + 1; j < object_count; j++) {
      if (!objects[j].active) continue;
      // Check AABB overlap
      F64 dx = Abs(objects[i].pos.x - objects[j].pos.x);
      F64 dy = Abs(objects[i].pos.y - objects[j].pos.y);
      F64 dz = Abs(objects[i].pos.z - objects[j].pos.z);
      F64 sx = (objects[i].size.x + objects[j].size.x) / 2;
      F64 sy = (objects[i].size.y + objects[j].size.y) / 2;
      F64 sz = (objects[i].size.z + objects[j].size.z) / 2;
      if (dx < sx && dy < sy && dz < sz) {
        // Simple elastic collision: reverse velocities
        F64 temp_vx = objects[i].vel.x;
        F64 temp_vy = objects[i].vel.y;
        objects[i].vel.x = objects[j].vel.x;
        objects[i].vel.y = objects[j].vel.y;
        objects[j].vel.x = temp_vx;
        objects[j].vel.y = temp_vy;
      }
    }
  }
}

// Calculate Center of Mass
U0 PhysicsCenterOfMass(Vector3 *com) {
  F64 total_mass = 0;
  com->x = 0; com->y = 0; com->z = 0;
  for (I64 i = 0; i < object_count; i++) {
    if (!objects[i].active) continue;
    com->x += objects[i].pos.x * objects[i].mass;
    com->y += objects[i].pos.y * objects[i].mass;
    com->z += objects[i].pos.z * objects[i].mass;
    total_mass += objects[i].mass;
  }
  if (total_mass > 0) {
    com->x /= total_mass;
    com->y /= total_mass;
    com->z /= total_mass;
  }
}

// Check Stability (Center of Mass within base)
Bool PhysicsIsStable(F64 base_width, F64 base_depth) {
  Vector3 com;
  PhysicsCenterOfMass(&com);
  return Abs(com.x) < base_width / 2 && Abs(com.z) < base_depth / 2;
}

PhysicsInit;
