// Games/Physics.HC - Enhanced Physics Module
#include "KernelA.HH"
#include "::/Apps/AGI.HC"

#define MAX_OBJECTS 128 // Reduced from 256
#define GRID_CELL_SIZE 16
#define FRICTION_COEFF 0.1
#define DAMPING 0.99

class Vector3 {
  F64 x, y, z;
};

class PhysicsObject {
  Vector3 pos;
  Vector3 vel;
  Vector3 ang_vel;
  F64 mass;
  F64 width, height, depth;
  U8 active : 1;
  U8 is_static : 1;
  Matrix3 orient;
};

class PhysicsState {
  PhysicsObject objects[MAX_OBJECTS];
  I64 object_count;
  F64 stability;
};

PhysicsState physics;
U8 *log_buffer = NULL;
I64 log_buffer_idx = 0;

#define LOG(level, fmt, args...) if (cfg.log_level >= level) LogBuffer(fmt, ##args)

U0 LogBuffer(U8 *fmt, ...) {
  if (!log_buffer) return;
  I64 len = StrPrint(&log_buffer[log_buffer_idx], fmt, ...);
  log_buffer_idx += len;
  if (log_buffer_idx > cfg.page_size - 128) {
    Print("%s", log_buffer);
    log_buffer_idx = 0;
    MemSet(log_buffer, 0, cfg.page_size);
  }
}

U0 PhysicsInit() {
  MemSet(&physics, 0, sizeof(PhysicsState));
  physics.stability = 100.0;
  log_buffer = MemBlkAlloc(cfg.page_size, MEM_ALIGN_4K);
  if (!log_buffer) {
    Print("Fatal: Log buffer allocation failed.\n");
    Halt;
  }
  MemSet(log_buffer, 0, cfg.page_size);
  LOG(LOG_NORMAL, "Physics initialized.\n");
}

U0 PhysicsAddObject(F64 x, F64 y, F64 z, F64 mass, F64 w, F64 h, F64 d, U8 is_static) {
  if (physics.object_count >= MAX_OBJECTS) {
    LOG(LOG_NORMAL, "Warning: Physics object limit reached.\n");
    return;
  }
  I64 idx = physics.object_count++;
  physics.objects[idx].pos.x = x;
  physics.objects[idx].pos.y = y;
  physics.objects[idx].pos.z = z;
  physics.objects[idx].vel.x = 0;
  physics.objects[idx].vel.y = 0;
  physics.objects[idx].vel.z = 0;
  physics.objects[idx].ang_vel.x = 0;
  physics.objects[idx].ang_vel.y = 0;
  physics.objects[idx].ang_vel.z = 0;
  physics.objects[idx].mass = mass;
  physics.objects[idx].width = w;
  physics.objects[idx].height = h;
  physics.objects[idx].depth = d;
  physics.objects[idx].active = 1;
  physics.objects[idx].is_static = is_static;
  Matrix3Identity(&physics.objects[idx].orient);
  LOG(LOG_VERBOSE, "Added object %d at (%f, %f, %f).\n", idx, x, y, z);
}

U0 PhysicsUpdate(F64 delta_time) {
  for (I64 i = 0; i < MAX_OBJECTS; i++) {
    if (!physics.objects[i].active || physics.objects[i].is_static) continue;
    physics.objects[i].vel.y -= 9.81 * delta_time;
    physics.objects[i].pos.x += physics.objects[i].vel.x * delta_time;
    physics.objects[i].pos.y += physics.objects[i].vel.y * delta_time;
    physics.objects[i].pos.z += physics.objects[i].vel.z * delta_time;
    physics.objects[i].vel.x *= DAMPING;
    physics.objects[i].vel.y *= DAMPING;
    physics.objects[i].vel.z *= DAMPING;
    Matrix3Rotate(&physics.objects[i].orient, physics.objects[i].ang_vel.x * delta_time,
                  physics.objects[i].ang_vel.y * delta_time, physics.objects[i].ang_vel.z * delta_time);
    if (physics.objects[i].pos.y < 0) {
      physics.objects[i].pos.y = 0;
      physics.objects[i].vel.y = -physics.objects[i].vel.y * 0.5;
      physics.objects[i].vel.x *= FRICTION_COEFF;
      physics.objects[i].vel.z *= FRICTION_COEFF;
    }
  }
}

U0 PhysicsCheckCollisions() {
  physics.stability = 100.0;
  for (I64 i = 0; i < MAX_OBJECTS; i++) {
    if (!physics.objects[i].active) continue;
    for (I64 j = i + 1; j < MAX_OBJECTS; j++) {
      if (!physics.objects[j].active || (physics.objects[i].is_static && physics.objects[j].is_static)) continue;
      F64 dx = physics.objects[i].pos.x - physics.objects[j].pos.x;
      F64 dy = physics.objects[i].pos.y - physics.objects[j].pos.y;
      F64 dz = physics.objects[i].pos.z - physics.objects[j].pos.z;
      F64 dist = Sqrt(dx * dx + dy * dy + dz * dz);
      F64 min_dist = (physics.objects[i].width + physics.objects[j].width) / 2;
      if (dist < min_dist) {
        F64 overlap = min_dist - dist;
        F64 nx = dx / dist;
        F64 ny = dy / dist;
        F64 nz = dz / dist;
        if (!physics.objects[i].is_static) {
          physics.objects[i].pos.x += nx * overlap * 0.5;
          physics.objects[i].pos.y += ny * overlap * 0.5;
          physics.objects[i].pos.z += nz * overlap * 0.5;
        }
        if (!physics.objects[j].is_static) {
          physics.objects[j].pos.x -= nx * overlap * 0.5;
          physics.objects[j].pos.y -= ny * overlap * 0.5;
          physics.objects[j].pos.z -= nz * overlap * 0.5;
        }
        F64 rel_vel_x = physics.objects[i].vel.x - physics.objects[j].vel.x;
        F64 rel_vel_y = physics.objects[i].vel.y - physics.objects[j].vel.y;
        F64 rel_vel_z = physics.objects[i].vel.z - physics.objects[j].vel.z;
        F64 impulse = -(1.0 + 0.8) * (rel_vel_x * nx + rel_vel_y * ny + rel_vel_z * nz) /
                      (1.0 / physics.objects[i].mass + 1.0 / physics.objects[j].mass);
        if (!physics.objects[i].is_static) {
          physics.objects[i].vel.x += impulse * nx / physics.objects[i].mass;
          physics.objects[i].vel.y += impulse * ny / physics.objects[i].mass;
          physics.objects[i].vel.z += impulse * nz / physics.objects[i].mass;
        }
        if (!physics.objects[j].is_static) {
          physics.objects[j].vel.x -= impulse * nx / physics.objects[j].mass;
          physics.objects[j].vel.y -= impulse * ny / physics.objects[j].mass;
          physics.objects[j].vel.z -= impulse * nz / physics.objects[j].mass;
        }
        physics.stability -= overlap * 10.0;
        LOG(LOG_VERBOSE, "Collision between %d and %d, stability: %f.\n", i, j, physics.stability);
      }
    }
  }
  physics.stability = Clamp(physics.stability, 0.0, 100.0);
}

F64 PhysicsStability(F64 width, F64 depth) {
  return physics.stability;
}

U0 PhysicsCleanup() {
  if (log_buffer) {
    MemBlkFree(log_buffer);
    log_buffer = NULL;
  }
  MemSet(&physics, 0, sizeof(PhysicsState));
  AGILog(LOG_NORMAL, "Physics cleaned up.\n");
}
