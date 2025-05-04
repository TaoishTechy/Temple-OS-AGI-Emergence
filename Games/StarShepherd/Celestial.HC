// Celestial.HC - Celestial Dynamics Module for TempleOS
#include "KernelA.HH"

#define MAX_STARS 32 // Max stars in constellation
#define GRAVITY_CONSTANT 0.1 // Scaled for game
#define MIN_DISTANCE 1.0 // Prevent division by zero

// 3D Vector
class Vector3 {
  F64 x, y, z;
};

// Star
class Star {
  Vector3 pos; // Position in 3D space
  Vector3 vel; // Velocity
  F64 mass; // Mass in arbitrary units
  U8 active : 1; // Active flag
};

// Celestial State
class CelestialState {
  Star stars[MAX_STARS];
  I64 star_count;
};

// Global State
CelestialState celestial;

// Initialize Celestial System
U0 CelestialInit() {
  MemSet(&celestial, 0, sizeof(CelestialState));
  celestial.star_count = 0;
}

// Add Star
I64 CelestialAddStar(F64 x, F64 y, F64 z, F64 mass) {
  if (celestial.star_count >= MAX_STARS) return -1;
  I64 idx = celestial.star_count++;
  celestial.stars[idx].pos.x = x;
  celestial.stars[idx].pos.y = y;
  celestial.stars[idx].pos.z = z;
  celestial.stars[idx].vel.x = 0;
  celestial.stars[idx].vel.y = 0;
  celestial.stars[idx].vel.z = 0;
  celestial.stars[idx].mass = mass;
  celestial.stars[idx].active = 1;
  return idx;
}

// Update Celestial Dynamics (N-body gravity)
U0 CelestialUpdate(F64 delta_time) {
  for (I64 i = 0; i < celestial.star_count; i++) {
    if (!celestial.stars[i].active) continue;
    Vector3 accel = {0, 0, 0};
    for (I64 j = 0; j < celestial.star_count; j++) {
      if (i == j || !celestial.stars[j].active) continue;
      F64 dx = celestial.stars[j].pos.x - celestial.stars[i].pos.x;
      F64 dy = celestial.stars[j].pos.y - celestial.stars[i].pos.y;
      F64 dz = celestial.stars[j].pos.z - celestial.stars[i].pos.z;
      F64 dist_sq = dx*dx + dy*dy + dz*dz + MIN_DISTANCE;
      F64 dist = Sqrt(dist_sq);
      F64 force = GRAVITY_CONSTANT * celestial.stars[i].mass * celestial.stars[j].mass / dist_sq;
      accel.x += force * dx / dist / celestial.stars[i].mass;
      accel.y += force * dy / dist / celestial.stars[i].mass;
      accel.z += force * dz / dist / celestial.stars[i].mass;
    }
    celestial.stars[i].vel.x += accel.x * delta_time;
    celestial.stars[i].vel.y += accel.y * delta_time;
    celestial.stars[i].vel.z += accel.z * delta_time;
    celestial.stars[i].pos.x += celestial.stars[i].vel.x * delta_time;
    celestial.stars[i].pos.y += celestial.stars[i].vel.y * delta_time;
    celestial.stars[i].pos.z += celestial.stars[i].vel.z * delta_time;
  }
}

// Calculate Pattern Alignment (Simplified: variance from ideal positions)
F64 CelestialAlignment() {
  F64 variance = 0.0;
  I64 active_stars = 0;
  for (I64 i = 0; i < celestial.star_count; i++) {
    if (!celestial.stars[i].active) continue;
    // Ideal position: circular orbit around origin
    F64 dist = Sqrt(celestial.stars[i].pos.x*celestial.stars[i].pos.x +
                     celestial.stars[i].pos.y*celestial.stars[i].pos.y +
                     celestial.stars[i].pos.z*celestial.stars[i].pos.z);
    variance += (dist - 50.0)*(dist - 50.0); // Ideal radius: 50 units
    active_stars++;
  }
  if (active_stars == 0) return 0.0;
  return 1.0 - Min(Sqrt(variance / active_stars) / 50.0, 1.0); // 0 to 1
}

// Check Collisions (Deactivate stars on close approach)
U0 CelestialCheckCollisions() {
  for (I64 i = 0; i < celestial.star_count; i++) {
    if (!celestial.stars[i].active) continue;
    for (I64 j = i + 1; j < celestial.star_count; j++) {
      if (!celestial.stars[j].active) continue;
      F64 dx = celestial.stars[i].pos.x - celestial.stars[j].pos.x;
      F64 dy = celestial.stars[i].pos.y - celestial.stars[j].pos.y;
      F64 dz = celestial.stars[i].pos.z - celestial.stars[j].pos.z;
      F64 dist_sq = dx*dx + dy*dy + dz*dz;
      if (dist_sq < 4.0) { // Collision threshold: 2 units
        celestial.stars[i].active = 0;
        celestial.stars[j].active = 0;
      }
    }
  }
}

CelestialInit;
