// Games/TempleBuilder/TempleBuilder.HC - 2D Construction Simulation
#include "KernelA.HH"
#include "::/Apps/AGI.HC"

#define GRID_SIZE 8
#define MAX_RESOURCES 100

class BuildState {
  U8 grid[GRID_SIZE][GRID_SIZE];
  I64 cursor_x, cursor_y;
  I64 stone, wood;
};

BuildState build;
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

U0 BuildInit() {
  MemSet(&build, 0, sizeof(BuildState));
  build.stone = 50;
  build.wood = 50;
  build.cursor_x = GRID_SIZE / 2;
  build.cursor_y = GRID_SIZE / 2;
  log_buffer = MemBlkAlloc(cfg.page_size, MEM_ALIGN_4K);
  if (!log_buffer) {
    Print("Fatal: Log buffer allocation failed.\n");
    Halt;
  }
  MemSet(log_buffer, 0, cfg.page_size);
  LOG(LOG_NORMAL, "TempleBuilder initialized.\n");
}

U0 BuildRender() {
  GrCls;
  for (I64 y = 0; y < GRID_SIZE; y++) {
    for (I64 x = 0; x < GRID_SIZE; x++) {
      U32 color = (x == build.cursor_x && y == build.cursor_y) ? YELLOW : WHITE;
      U8 ch = build.grid[y][x] == 1 ? 'S' : build.grid[y][x] == 2 ? 'W' : '.';
      GrPrint(x * 32, y * 32, "%c", ch, color);
    }
  }
  GrPrint(0, GRID_SIZE * 32, "Stone: %d  Wood: %d", build.stone, build.wood);
  GrPrint(0, 480 - 16, "Ethics: %d  Emotion: %d", ethics, emotion);
  GrUpdate;
}

U0 BuildUpdate() {
  I64 build_count = 0;
  for (I64 y = 0; y < GRID_SIZE; y++) {
    for (I64 x = 0; x < GRID_SIZE; x++) {
      if (build.grid[y][x] > 0) build_count++;
    }
  }
  UpdateKnowledgeGraph(FNV1aHash(build_count), build.stone * 1000, 0);
  if (build_count > GRID_SIZE * GRID_SIZE / 2) {
    AGIUpdateEmotion(EMOTION_HAPPY);
  } else if (build.stone + build.wood < 20) {
    AGIUpdateEmotion(EMOTION_CONCERNED);
  } else {
    AGIUpdateEmotion(EMOTION_CURIOUS);
  }
}

U0 BuildCleanup() {
  if (log_buffer) {
    MemBlkFree(log_buffer);
    log_buffer = NULL;
  }
  MemSet(&build, 0, sizeof(BuildState));
  AGILog(LOG_NORMAL, "TempleBuilder cleaned up.\n");
}

U0 TempleBuilder() {
  BuildInit();
  while (build.stone > 0 || build.wood > 0) {
    BuildRender();
    BuildUpdate();
    I64 key = KbdGetChar();
    if (key == CH_ESC) {
      BuildCleanup();
      return;
    }
    switch (key) {
      case 'w': build.cursor_y--; break;
      case 's': build.cursor_y++; break;
      case 'a': build.cursor_x--; break;
      case 'd': build.cursor_x++; break;
      case '1':
        if (build.stone >= 10 && build.grid[build.cursor_y][build.cursor_x] == 0) {
          build.grid[build.cursor_y][build.cursor_x] = 1;
          build.stone -= 10;
        }
        break;
      case '2':
        if (build.wood >= 10 && build.grid[build.cursor_y][build.cursor_x] == 0) {
          build.grid[build.cursor_y][build.cursor_x] = 2;
          build.wood -= 10;
        }
        break;
    }
    build.cursor_x = Clamp(build.cursor_x, 0, GRID_SIZE - 1);
    build.cursor_y = Clamp(build.cursor_y, 0, GRID_SIZE - 1);
  }
  GrCls;
  GrPrint(0, 0, "Temple Built! Stone: %d  Wood: %d", build.stone, build.wood);
  GrUpdate;
  Sleep(2000);
  BuildCleanup();
}

TempleBuilder;
