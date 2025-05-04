// Physics.HC - Enhanced Physics Module for TempleOS
#include "KernelA.HH"
#include "::/AGI.HC"

#define GRAVITY 9.8
#define MAX_OBJECTS 32
#define COLLISION_THRESHOLD 0.1
#define FRICTION_COEFF 0.1
#define DAMPING_FACTOR 0.99
#define MIN_DISTANCE 0.1

#define LOG_MINIMAL 0
#define LOG_NORMAL  1
#define LOG_VERBOSE 2
#define LOG(level, fmt, args...) if (cfg.log_level >= level) PhysicsLog(fmt, ##args)

class Vector3 {
  F64 x, y, z;
};

class PhysicsObject {
  Vector3 pos;
  Vector3 vel;
  Vector3 ang_vel;
  F64 mass;
  Vector3 size;
  Vector3 orientation;
  U8 active : 1;
  U8 fixed : 1;
};

PhysicsObject objects[MAX_OBJECTS];
I64 object_count = 0;
U8 *log_buffer = NULL;
I64 log_buffer_idx = 0;

U0 PhysicsLog(U8 *fmt, ...) {
  if (!log_buffer) return;
  I64 len = StrPrint(&log_buffer[log_buffer_idx], fmt, ...);
  log_buffer_idx += len;
  if (log_buffer_idx > cfg.page_size - 256) {
    Print("%s", log_buffer);
    log_buffer_idx = 0;
    MemSet(log_buffer, 0, cfg.page_size);
  }
}

U0 PhysicsInit() {
  MemSet(objects, 0, sizeof(PhysicsObject) * MAX_OBJECTS);
  object_count = 0;
  log_buffer = MemBlkAlloc(cfg.page_size, MEM_ALIGN_4K);
  if (!log_buffer) {
    Print("Fatal: Physics log buffer allocation failed.\n");
    Halt;
  }
  LOG(LOG_NORMAL, "Physics initialized: %d objects available.\n", MAX_OBJECTS);
}

I64 PhysicsAddObject(F64 x, F64 y, F64 z, F64 mass, F64 width, F64 height, F64 depth, Bool fixed) {
  if (object_count >= MAX_OBJECTS) {
    LOG(LOG_NORMAL, "Error: Max objects (%d) reached.\n", MAX_OBJECTS);
    return -1;
  }
  for (I64 i = 0; i < object_count; i++) {
    if (!objects[i].active) continue;
    F64 dx = Abs(x - objects[i].pos.x);
    F64 dy = Abs(y - objects[i].pos.y);
    F64 dz = Abs(z - objects[i].pos.z);
    F64 sx = (width + objects[i].size.x) / 2;
    F64 sy = (height + objects[i].size.y) / 2;
    F64 sz = (depth + objects[i].size.z) / 2;
    if (dx < sx && dy < sy && dz < sz) {
      LOG(LOG_NORMAL, "Error: New object at (%f,%f,%f) overlaps existing object.\n", x, y, z);
      return -1;
    }
  }
  I64 idx = object_count++;
  objects[idx].pos.x = x;
  objects[idx].pos.y = y;
  objects[idx].pos.z = z;
  objects[idx].vel.x = 0;
  objects[idx].vel.y = 0;
  objects[idx].vel.z = 0;
  objects[idx].ang_vel.x = 0;
  objects[idx].ang_vel.y = 0;
  objects[idx].ang_vel.z = 0;
  objects[idx].mass = Max(mass, 0.1);
  objects[idx].size.x = width;
  objects[idx].size.y = height;
  objects[idx].size.z = depth;
  objects[idx].orientation.x = 0;
  objects[idx].orientation.y = 0;
  objects[idx].orientation.z = 0;
  objects[idx].active = 1;
  objects[idx].fixed = fixed;
  LOG(LOG_VERBOSE, "Added object %d at (%f,%f,%f), mass=%f, fixed=%d.\n", idx, x, y, z, mass, fixed);
  return idx;
}

U0 PhysicsApplyForce(I64 idx, F64 fx, F64 fy, F64 fz) {
  if (idx < 0 || idx >= object_count || !objects[idx].active || objects[idx].fixed) return;
  objects[idx].vel.x += fx / objects[idx].mass;
  objects[idx].vel.y += fy / objects[idx].mass;
  objects[idx].vel.z += fz / objects[idx].mass;
  LOG(LOG_VERBOSE, "Applied force (%f,%f,%f) to object %d.\n", fx, fy, fz, idx);
}

U0 PhysicsApplyTorque(I64 idx, F64 tx, F64 ty, F64 tz) {
  if (idx < 0 || idx >= object_count || !objects[idx].active || objects[idx].fixed) return;
  objects[idx].ang_vel.x += tx / objects[idx].mass;
  objects[idx].ang_vel.y += ty / objects[idx].mass;
  objects[idx].ang_vel.z += tz / objects[idx].mass;
  LOG(LOG_VERBOSE, "Applied torque (%f,%f,%f) to object %d.\n", tx, ty, tz, idx);
}

U0 PhysicsUpdate(F64 delta_time) {
  for (I64 i = 0; i < object_count; i++) {
    if (!objects[i].active || objects[i].fixed) continue;
    objects[i].vel.y -= objects[i].mass * GRAVITY * delta_time;
    if (objects[i].pos.y <= objects[i].size.y / 2) {
      objects[i].vel.x *= (1.0 - FRICTION_COEFF * delta_time);
      objects[i].vel.z *= (1.0 - FRICTION_COEFF * delta_time);
      objects[i].ang_vel.x *= (1.0 - FRICTION_COEFF * delta_time);
      objects[i].ang_vel.y *= (1.0 - FRICTION_COEFF * delta_time);
      objects[i].ang_vel.z *= (1.0 - FRICTION_COEFF * delta_time);
    }
    objects[i].vel.x *= DAMPING_FACTOR;
    objects[i].vel.y *= DAMPING_FACTOR;
    objects[i].vel.z *= DAMPING_FACTOR;
    objects[i].ang_vel.x *= DAMPING_FACTOR;
    objects[i].ang_vel.y *= DAMPING_FACTOR;
    objects[i].ang_vel.z *= DAMPING_FACTOR;
    objects[i].pos.x += objects[i].vel.x * delta_time;
    objects[i].pos.y += objects[i].vel.y * delta_time;
    objects[i].pos.z += objects[i].vel.z * delta_time;
    objects[i].orientation.x += objects[i].ang_vel.x * delta_time;
    objects[i].orientation.y += objects[i].ang_vel.y * delta_time;
    objects[i].orientation.z += objects[i].ang_vel.z * delta_time;
    if (objects[i].pos.y < objects[i].size.y / 2) {
      objects[i].pos.y = objects[i].size.y / 2;
      objects[i].vel.y = 0;
      LOG(LOG_VERBOSE, "Object %d grounded at y=%f.\n", i, objects[i].pos.y);
    }
  }
}

U0 PhysicsCheckCollisions() {
  // Simple spatial partitioning: check only nearby objects
  for (I64 i = 0; i < object_count; i++) {
    if (!objects[i].active || objects[i].fixed) continue;
    for (I64 j = i + 1 J; j < object_count; j++) {
      if (!objects[j].active || objects[j].fixed) continue;
      // Skip if objects are too far apart (optimization)
      F64 dx = Abs(objects[i].pos.x - objects[j].pos.x);
      if (dx > (objects[i].size.x + objects[j].size.x)) continue;
      F64 dy = Abs(objects[i].pos.y - objects[j].pos.y);
      if (dy > (objects[i].size.y + objects[j].size.y)) continue;
      F64 dz = Abs(objects[i].pos.z - objects[j].pos.z);
      if (dz > (objects[i].size.z + objects[j].size.z)) continue;
      F64 sx = (objects[i].size.x + objects[j].size.x) / 2;
      F64 sy = (objects[i].size.y + objects[j].size.y) / 2;
      F64 sz = (objects[i].size.z + objects[j].size.z) / 2;
      if (dx < sx && dy < sy && dz < sz) {
        F64 m1 = objects[i].mass, m2 = objects[j].mass;
        F64 u1 = objects[i].vel.y, u2 = objects[j].vel.y;
        F64 v1 = (m1 * u1 + m2 * u2 - m2 * (u1 - u2)) / (m1 + m2);
        F64 v2 = (m1 * u1 + m2 * u2 - m1 * (u2 - u1)) / (m1 + m2);
        objects[i].vel.y = v1;
        objects[j].vel.y = v2;
        objects[i].ang_vel.y += (u1 - u2) * 0.01;
        objects[j].ang_vel.y -= (u1 - u2) * 0.01;
        LOG(LOG_NORMAL, "Collision between objects %d and %d.\n", i, j);
        UpdateKnowledgeGraph(RandU64() % cfg.page_size, 50000, 1);
      }
    }
  }
}

U0 PhysicsCenterOfMass(Vector3 *com) {
  F64 total_mass = 0;
  com->x = 0; com->y = 0; com->z = 0;
  for (I64 i = 0; i < object_count; i++) {
    if (!objects[i].active) continue;
    total_mass += objects[i].mass; // Cache total_mass
    com->x += objects[i].pos.x * objects[i].mass;
    com->y += objects[i].pos.y * objects[i].mass;
    com->z += objects[i].pos.z * objects[i].mass;
  }
  if (total_mass > 0) {
    com->x /= total_mass;
    com->y /= total_mass;
    com->z /= total_mass;
  }
}

F64 PhysicsStability(F64 base_width, F64 base_depth) {
  Vector3 com;
  PhysicsCenterOfMass(&com);
  Bool is_stable = Abs(com.x) < base_width / 2 && Abs(com.z) < base_depth / 2;
  F64 stability_score = is_stable ? 100.0 : 50.0;
  F64 total_ang_vel = 0.0;
  for (I64 i = 0; i < object_count; i++) {
    if (!objects[i].active) continue;
    total_ang_vel += Abs(objects[i].ang_vel.x) + Abs(objects[i].ang_vel.y) + Abs(objects[i].ang_vel.z);
  }
  stability_score -= Min(total_ang_vel * 10.0, 50.0);
  stability_score = Max(stability_score, 0.0);
  UpdateKnowledgeGraph(stability_score * 1000, is_stable ? 100000 : 50000, 0);
  return stability_score;
}

U0 PhysicsCleanup() {
  if (log_buffer) {
    MemBlkFree(log_buffer);
    log_buffer = NULL;
  }
  object_count = 0;
  MemSet(objects, 0, sizeof(PhysicsObject) * MAX_OBJECTS);
  LOG(LOG_NORMAL, "Physics cleaned up.\n");
}

PhysicsInit;
