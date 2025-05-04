// ArkBuilder.HC (Hypothesized)
#include "KernelA.HH"
#include "Gr3D.HH"
#include "::/AGI.HC"
#include "::/Games/Physics.HC"

#define GRID_WIDTH 16
#define GRID_DEPTH 16
#define GRID_HEIGHT 16

class ArkState {
  U8 grid[GRID_WIDTH][GRID_HEIGHT][GRID_DEPTH];
  U64 workers;
  F64 stability_score;
  Vector3 camera_pos;
  Vector3 camera_rot;
  I64 selected_x, selected_y, selected_z;
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
  ark.camera_pos.x = 0;
  ark.camera_pos.y = 64;
  ark.camera_pos.z = -128;
  ark.selected_x = GRID_WIDTH / 2;
  ark.selected_y = GRID_HEIGHT / 2;
  ark.selected_z = GRID_DEPTH / 2;
  PhysicsInit();
  log_buffer = MemBlkAlloc(cfg.page_size, MEM_ALIGN_4K);
  if (!log_buffer) {
    Print("Fatal: Log buffer allocation failed.\n");
    Halt;
  }
}

U0 ArkCleanup() {
  if (log_buffer) {
    MemBlkFree(log_buffer);
    log_buffer = NULL;
  }
  PhysicsCleanup();
  AGILog(LOG_NORMAL, "ArkBuilder cleaned up.\n");
}

U0 ArkBuilder() {
  ArkInit();
  // Game loop with KbdGetChar, PhysicsUpdate, etc.
  ArkCleanup();
}
