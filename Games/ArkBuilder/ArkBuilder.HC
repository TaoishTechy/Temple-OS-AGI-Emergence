// Games/ArkBuilder/ArkBuilder.HC - 3D Physics-Based Ark-Building
#include "KernelA.HH"
#include "Gr3D.HH"
#include "::/Apps/AGI.HC"
#include "::/Games/Physics.HC"

#define GRID_WIDTH 16
#define GRID_HEIGHT 16
#define GRID_DEPTH 16
#define MAX_TIME 3600
#define USE_3D TRUE

class ArkState {
  U8 grid[GRID_WIDTH][GRID_HEIGHT][GRID_DEPTH];
  U64 workers;
  F64 stability_score;
  Vector3 camera_pos;
  Vector3 camera_rot;
  I64 selected_x, selected_y, selected_z;
  I64 block_count;
};

ArkState ark;
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

U0 ArkInit() {
  MemSet(&ark, 0, sizeof(ArkState));
  ark.workers = 10;
  ark.time_left = MAX_TIME;
  ark.camera_pos.x = 0;
  ark.camera_pos.y = 64;
  ark.camera_pos.z = -128;
  ark.camera_rot.x = 0;
  ark.camera_rot.y = 0;
  ark.camera_rot.z = 0;
  ark.selected_x = GRID_WIDTH / 2;
  ark.selected_y = GRID_HEIGHT / 2;
  ark.selected_z = GRID_DEPTH / 2;
  ark.block_count = 0;
  PhysicsInit();
  log_buffer = MemBlkAlloc(cfg.page_size, MEM_ALIGN_4K);
  if (!log_buffer) {
    Print("Fatal: Log buffer allocation failed.\n");
    Halt;
  }
  MemSet(log_buffer, 0, cfg.page_size);
  LOG(LOG_NORMAL, "ArkBuilder initialized.\n");
}

U0 ArkRender() {
  if (USE_3D) {
    Gr3DCamSet(ark.camera_pos.x, ark.camera_pos.y, ark.camera_pos.z,
               ark.camera_rot.x, ark.camera_rot.y, ark.camera_rot.z);
    Gr3DCls;
    Gr3DMeshDraw(0, 0, 0, GRID_WIDTH * 8, 2, GRID_DEPTH * 8, BROWN);
    for (I64 z = 0; z < GRID_DEPTH; z++) {
      for (I64 y = 0; y < GRID_HEIGHT; y++) {
        for (I64 x = 0; x < GRID_WIDTH; x++) {
          if (ark.grid[x][y][z] == 1) {
            F64 px = (x - GRID_WIDTH / 2) * 8;
            F64 py = y * 8;
            F64 pz = (z - GRID_DEPTH / 2) * 8;
            Gr3DMeshDraw(px, py, pz, 4, 4, 4, BROWN);
          }
        }
      }
    }
    F64 sx = (ark.selected_x - GRID_WIDTH / 2) * 8;
    F64 sy = ark.selected_y * 8;
    F64 sz = (ark.selected_z - GRID_DEPTH / 2) * 8;
    Gr3DMeshWireframe(sx, sy, sz, 4, 4, 4, YELLOW);
  } else {
    GrCls;
    for (I64 z = 0; z < GRID_DEPTH; z++) {
      for (I64 x = 0; x < GRID_WIDTH; x++) {
        U8 ch = (ark.grid[x][ark.selected_y][z] == 1) ? 'B' : '.';
        U32 color = (ark.grid[x][ark.selected_y][z] == 1) ? BROWN : BLACK;
        GrPrint(x * 8, z * 8, "%c", ch, color);
        if (x == ark.selected_x && z == ark.selected_z) {
          GrRect(x * 8, z * 8, 8, 8, YELLOW);
        }
      }
    }
  }
  GrPrint(0, GRID_DEPTH * 8, "Time: %.1f  Workers: %d  Stability: %.2f", ark.time_left / 60.0, ark.workers, ark.stability_score);
  GrPrint(0, 480 - 16, "Ethics: %d  Emotion: %d", ethics, emotion);
  GrUpdate;
}

U0 ArkUpdate(F64 delta_time) {
  PhysicsUpdate(delta_time);
  PhysicsCheckCollisions();
  ark.stability_score = PhysicsStability(GRID_WIDTH * 8, GRID_DEPTH * 8);
  ark.block_count = 0;
  for (I64 z = 0; z < GRID_DEPTH; z++) {
    for (I64 y = 0; y < GRID_HEIGHT; y++) {
      for (I64 x = 0; x < GRID_WIDTH; x++) {
        if (x < 0 || x >= GRID_WIDTH || y < 0 || y >= GRID_HEIGHT || z < 0 || z >= GRID_DEPTH) continue;
        if (ark.grid[x][y][z] == 1) ark.block_count++;
      }
    }
  }
  UpdateKnowledgeGraph(FNV1aHash(ark.stability_score), ark.block_count * 1000, 0);
  if (ark.block_count > 100 || ark.workers > 20) {
    AGIAdjustEthics(-1);
    LOG(LOG_NORMAL, "Warning: Overbuilding detected.\n");
  }
  ethics = Clamp(ethics, 0, ETHICS_MAX);
  static F64 prev_stability = 0.0;
  if (ark.stability_score < 50.0) {
    AGIUpdateEmotion(EMOTION_CONCERNED);
  } else if (ark.stability_score > prev_stability + 10.0) {
    AGIUpdateEmotion(EMOTION_HAPPY);
  } else {
    AGIUpdateEmotion(EMOTION_CURIOUS);
  }
  prev_stability = ark.stability_score;
}

U0 ArkCleanup() {
  if (log_buffer) {
    MemBlkFree(log_buffer);
    log_buffer = NULL;
  }
  MemSet(&ark, 0, sizeof(ArkState));
  PhysicsCleanup();
  AGILog(LOG_NORMAL, "ArkBuilder cleaned up.\n");
}

U0 ArkBuilder() {
  ArkInit();
  F64 delta_time = 1.0 / 60.0;
  while (ark.time_left > 0 && ark.stability_score < 90.0) {
    ArkRender();
    ArkUpdate(delta_time);
    ark.time_left -= delta_time;
    I64 key = KbdGetChar();
    if (key == CH_ESC) {
      ArkCleanup();
      return;
    }
    switch (key) {
      case 'w': ark.selected_z--; break;
      case 's': ark.selected_z++; break;
      case 'a': ark.selected_x--; break;
      case 'd': ark.selected_x++; break;
      case 'q': ark.selected_y--; break;
      case 'e': ark.selected_y++; break;
      case '1':
        if (ark.workers >= 1 && ark.grid[ark.selected_x][ark.selected_y][ark.selected_z] == 0) {
          ark.grid[ark.selected_x][ark.selected_y][ark.selected_z] = 1;
          ark.workers--;
          PhysicsAddObject((ark.selected_x - GRID_WIDTH / 2) * 8, ark.selected_y * 8,
                           (ark.selected_z - GRID_DEPTH / 2) * 8, 1.0, 8, 8, 8, FALSE);
        }
        break;
      case '2':
        if (ark.workers >= 1) {
          ark.workers--;
          ark.stone += 10;
          ark.wood += 10;
        }
        break;
      case '3':
        if (ark.stone >= 20 && ark.wood >= 20) {
          ark.workers++;
          ark.stone -= 20;
          ark.wood -= 20;
        }
        break;
      case 'i': ark.camera_pos.y += 8; break;
      case 'k': ark.camera_pos.y -= 8; break;
      case 'j': ark.camera_rot.y += 0.1; break;
      case 'l': ark.camera_rot.y -= 0.1; break;
    }
    ark.selected_x = Clamp(ark.selected_x, 0, GRID_WIDTH - 1);
    ark.selected_y = Clamp(ark.selected_y, 0, GRID_HEIGHT - 1);
    ark.selected_z = Clamp(ark.selected_z, 0, GRID_DEPTH - 1);
    if (ethics < 5) {
      GrPrint(0, GRID_DEPTH * 8 + 32, "Build with wisdom!");
      Sleep(500);
    }
    if (emotion == EMOTION_CONCERNED) {
      GrPrint(0, GRID_DEPTH * 8 + 48, "The ark falters, stabilize it!");
      Sleep(500);
    }
  }
  if (USE_3D) Gr3DCls; else GrCls;
  GrPrint(0, 0, "Ark Built! Stability: %.2f  Workers: %d", ark.stability_score, ark.workers);
  GrUpdate;
  Sleep(2000);
  ArkCleanup();
}

ArkBuilder;
