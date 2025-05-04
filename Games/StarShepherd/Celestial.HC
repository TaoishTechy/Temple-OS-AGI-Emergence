// Games/Celestial.HC - Celestial Dynamics Module
#include "KernelA.HH"
#include "::/Apps/AGI.HC"

#define MAX_BODIES 64
#define GRAV_CONST 0.1
#define MIN_DIST 0.1

class Vector3 {
  F64 x, y, z;
};

class CelestialBody {
  Vector3 pos;
  Vector3 vel;
  F64 mass;
  F64 width, height, depth;
  U8 active : 1;
};

class CelestialState {
  CelestialBody bodies[MAX_BODIES];
  I64 body_count;
};

CelestialState celestial;
U8 *log_buffer = NULL;
I64 log_buffer_idx = 0;

#define LOG(level, fmt, args...) if (cfg.log_level >= level) LogBuffer(fmt, ##args)

U0 LogBuffer(U8 *fmt, ...) {
  if (!log_buffer) return;
  I64 len = StrPrint(&log_buffer[log_buffer_idx], fmt, ...);
  log_buffer_idx += len;
  if (log_buffer_idx > cfg.page_size - 256) {
    Print("%s", log_buffer);
    log_buffer_idx = 0;
    MemSet(log_buffer, 0, cfg.page_size);
  }
}

U0 CelestialInit() {
  MemSet(&celestial, 0, sizeof(CelestialState));
  celestial.body_count = 0;
  log_buffer = MemBlkAlloc(cfg.page_size, MEM_ALIGN_4K);
  if (!log_buffer) {
    Print("Fatal: Log buffer allocation failed.\n");
    Halt;
  }
  MemSet(log_buffer, 0, cfg.page_size);
  LOG(LOG_NORMAL, "Celestial initialized.\n");
}

U0 CelestialAddBody(F64 x, F64 y, F64 z, F64 mass, F64 w, F64 h, F64 d) {
  if (celestial.body_count >= MAX_BODIES) {
    LOG(LOG_NORMAL, "Warning: Celestial body limit reached.\n");
    return;
  }
  I64 idx = celestial.body_count++;
  celestial.bodies[idx].pos.x = x;
  celestial.bodies[idx].pos.y = y;
  celestial.bodies[idx].pos.z = z;
  celestial.bodies[idx].vel.x = 0;
  celestial.bodies[idx].vel.y = 0;
  celestial.bodies[idx].vel.z = 0;
  celestial.bodies[idx].mass = mass;
  celestial.bodies[idx].width = w;
  celestial.bodies[idx].height = h;
  celestial.bodies[idx].depth = d;
  celestial.bodies[idx].active = 1;
  LOG(LOG_VERBOSE, "Added body %d at (%f, %f, %f).\n", idx, x, y, z);
}

U0 CelestialUpdate(F64 delta_time) {
  Vector3 forces[MAX_BODIES];
  MemSet(forces, 0, sizeof(Vector3) * MAX_BODIES);
  for (I64 i = 0; i < MAX_BODIES; i++) {
    if (!celestial.bodies[i].active) continue;
    for (I64 j = i + 1; j < MAX_BODIES; j++) {
      if (!celestial.bodies[j].active) continue;
      F64 dx = celestial.bodies[j].pos.x - celestial.bodies[i].pos.x;
      F64 dy = celestial.bodies[j].pos.y - celestial.bodies[i].pos.y;
      F64 dz = celestial.bodies[j].pos.z - celestial.bodies[i].pos.z;
      F64 dist = Sqrt(dx * dx + dy * dy + dz * dz);
      if (dist < MIN_DIST) dist = MIN_DIST;
      F64 force = GRAV_CONST * celestial.bodies[i].mass * celestial.bodies[j].mass / (dist * dist);
      F64 fx = force * dx / dist;
      F64 fy = force * dy / dist;
      F64 fz = force * dz / dist;
      forces[i].x += fx;
      forces[i].y += fy;
      forces[i].z += fz;
      forces[j].x -= fx;
      forces[j].y -= fy;
      forces[j].z -= fz;
    }
  }
  for (I64 i = 0; i < MAX_BODIES; i++) {
    if (!celestial.bodies[i].active) continue;
    celestial.bodies[i].vel.x += forces[i].x / celestial.bodies[i].mass * delta_time;
    celestial.bodies[i].vel.y += forces[i].y / celestial.bodies[i].mass * delta_time;
    celestial.bodies[i].vel.z += forces[i].z / celestial.bodies[i].mass * delta_time;
    celestial.bodies[i].pos.x += celestial.bodies[i].vel.x * delta_time;
    celestial.bodies[i].pos.y += celestial.bodies[i].vel.y * delta_time;
    celestial.bodies[i].pos.z += celestial.bodies[i].vel.z * delta_time;
  }
  LOG(LOG_VERBOSE, "Celestial updated: %d bodies.\n", celestial.body_count);
}

F64 CelestialAlignment() {
  F64 total_dist = 0.0;
  I64 pair_count = 0;
  for (I64 i = 0; i < MAX_BODIES; i++) {
    if (!celestial.bodies[i].active) continue;
    for (I64 j = i + 1; j < MAX_BODIES; j++) {
      if (!celestial.bodies[j].active) continue;
      F64 dx = celestial.bodies[j].pos.x - celestial.bodies[i].pos.x;
      F64 dy = celestial.bodies[j].pos.y - celestial.bodies[i].pos.y;
      F64 dz = celestial.bodies[j].pos.z - celestial.bodies[i].pos.z;
      total_dist += Sqrt(dx * dx + dy * dy + dz * dz);
      pair_count++;
    }
  }
  if (pair_count == 0) return 0.0;
  F64 avg_dist = total_dist / pair_count;
  return Clamp(1.0 - avg_dist / 100.0, 0.0, 1.0);
}

U0 CelestialCleanup() {
  if (log_buffer) {
    MemBlkFree(log_buffer);
    log_buffer = NULL;
  }
  MemSet(&celestial, 0, sizeof(CelestialState));
  AGILog(LOG_NORMAL, "Celestial cleaned up.\n");
}
