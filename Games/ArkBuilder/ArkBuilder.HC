// Games/ArkBuilder.HC - Physics-Based Ark-Building
#include "KernelA.HH"
#include "::/Apps/AGI.HC"
#include "::/Games/Physics.HC"

#define GRID_WIDTH 8
#define GRID_HEIGHT 8
#define GRID_DEPTH 8
#define MAX_TIME 3600

class ArkState {
  U8 grid[GRID_WIDTH][GRID_HEIGHT][GRID_DEPTH];
  U64 workers;
  F64 time_left;
  F64 stability_score;
  I64 selected_x, selected_y, selected_z;
  I64 block_count;
  I64 stone, wood;
};

ArkState ark;
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

U0 ArkInit() {
  MemSet(&ark, 0, sizeof(ArkState));
  ark.workers = 10;
  ark.time_left = MAX_TIME;
  ark.selected_x = GRID_WIDTH / 2;
  ark.selected_y = GRID_HEIGHT / 2;
  ark.selected_z = GRID_DEPTH / 2;
  ark.block_count = 0;
  ark.stone = 100;
  ark.wood = 100;
  ark.stability_score = 100.0;
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
  GrCls;
  for (I64 z = 0; z < GRID_DEPTH; z++) {
    for (I64 x = 0; x < GRID_WIDTH; x++) {
      U8 ch = ark.grid[x][ark.selected_y][z] == 1 ? 'B' : '.';
      U32 color = ark.grid[x][ark.selected_y][z] == 1 ? BROWN : BLACK;
      GrPrint(x * 16, z * 16, "%c", ch, color);
      if (x == ark.selected_x && z == ark.selected_z) {
        GrRect(x * 16, z * 16, 16, 16, YELLOW);
      }
    }
  }
  GrPrint(0, GRID_DEPTH * 16, "Time: %.1f  Workers: %d  Stability: %.2f", ark.time_left / 60.0, ark.workers, ark.stability_score);
  GrPrint(0, GRID_DEPTH * 16 + 16, "Stone: %d  Wood: %d", ark.stone, ark.wood);
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
        if (ark.grid[x][y][z] == 1) ark.block_count++;
      }
    }
  }
  UpdateKnowledgeGraph(FNV1aHash(ark.block_count), ark.stability_score * 1000, 0);
  if (ark.stability_score < 50.0) {
    AGIUpdateEmotion(EMOTION_CONCERNED);
    AGIAdjustEthics(-1);
  } else if (ark.stability_score > 80.0) {
    AGIUpdateEmotion(EMOTION_HAPPY);
    AGIAdjustEthics(1);
  } else {
    AGIUpdateEmotion(EMOTION_CURIOUS);
  }
  ark.time_left -= delta_time;
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
  while (ark.time_left > 0 && ark.stability_score > 20.0) {
    ArkRender();
    ArkUpdate(delta_time);
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
      case 'i': ark.selected_y--; break;
      case 'k': ark.selected_y++; break;
      case '1':
        if (ark.stone >= 10 && ark.grid[ark.selected_x][ark.selected_y][ark.selected_z] == 0) {
          ark.grid[ark.selected_x][ark.selected_y][ark.selected_z] = 1;
          ark.stone -= 10;
          PhysicsAddObject(ark.selected_x * 8, ark.selected_y * 8, ark.selected_z * 8, 1.0, 8, 8, 8, 0);
        }
        break;
      case '2':
        if (ark.wood >= 10 && ark.grid[ark.selected_x][ark.selected_y][ark.selected_z] == 0) {
          ark.grid[ark.selected_x][ark.selected_y][ark.selected_z] = 1;
          ark.wood -= 10;
          PhysicsAddObject(ark.selected_x * 8, ark.selected_y * 8, ark.selected_z * 8, 0.5, 8, 8, 8, 0);
        }
        break;
    }
    ark.selected_x = Clamp(ark.selected_x, 0, GRID_WIDTH - 1);
    ark.selected_y = Clamp(ark.selected_y, 0, GRID_HEIGHT - 1);
    ark.selected_z = Clamp(ark.selected_z, 0, GRID_DEPTH - 1);
  }
  GrCls;
  GrPrint(0, 0, "Ark Built! Blocks: %d  Stability: %.2f", ark.block_count, ark.stability_score);
  GrUpdate;
  Sleep(2000);
  ArkCleanup();
}

ArkBuilder;
