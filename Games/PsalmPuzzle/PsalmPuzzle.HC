// Games/PsalmPuzzle/PsalmPuzzle.HC - Tile-Matching Puzzle
#include "KernelA.HH"
#include "::/Apps/AGI.HC"

#define GRID_SIZE 4
#define MAX_MOVES 100

class PuzzleState {
  U8 grid[GRID_SIZE][GRID_SIZE];
  I64 cursor_x, cursor_y;
  I64 move_count;
};

PuzzleState puzzle;
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

U0 PuzzleInit() {
  MemSet(&puzzle, 0, sizeof(PuzzleState));
  // Initialize grid (simplified: numbers 1-15, 0 for empty)
  for (I64 y = 0; y < GRID_SIZE; y++) {
    for (I64 x = 0; x < GRID_SIZE; x++) {
      puzzle.grid[y][x] = y * GRID_SIZE + x + 1;
    }
  }
  puzzle.grid[GRID_SIZE-1][GRID_SIZE-1] = 0;
  puzzle.cursor_x = GRID_SIZE - 1;
  puzzle.cursor_y = GRID_SIZE - 1;
  puzzle.move_count = 0;
  log_buffer = MemBlkAlloc(cfg.page_size, MEM_ALIGN_4K);
  if (!log_buffer) {
    Print("Fatal: Log buffer allocation failed.\n");
    Halt;
  }
  MemSet(log_buffer, 0, cfg.page_size);
  LOG(LOG_NORMAL, "PsalmPuzzle initialized.\n");
}

U0 PuzzleRender() {
  GrCls;
  for (I64 y = 0; y < GRID_SIZE; y++) {
    for (I64 x = 0; x < GRID_SIZE; x++) {
      U32 color = (x == puzzle.cursor_x && y == puzzle.cursor_y) ? YELLOW : WHITE;
      if (puzzle.grid[y][x] == 0) {
        GrPrint(x * 32, y * 32, "  ", color);
      } else {
        GrPrint(x * 32, y * 32, "%2d", puzzle.grid[y][x], color);
      }
    }
  }
  GrPrint(0, GRID_SIZE * 32, "Moves: %d", puzzle.move_count);
  GrPrint(0, 480 - 16, "Ethics: %d  Emotion: %d", ethics, emotion);
  GrUpdate;
}

U0 PuzzleUpdate() {
  I64 solved = 1;
  for (I64 y = 0; y < GRID_SIZE; y++) {
    for (I64 x = 0; x < GRID_SIZE; x++) {
      if (puzzle.grid[y][x] != (y * GRID_SIZE + x + 1) % (GRID_SIZE * GRID_SIZE)) {
        solved = 0;
        break;
      }
    }
  }
  UpdateKnowledgeGraph(FNV1aHash(puzzle.move_count), solved ? 100000 : 50000, 0);
  if (solved) {
    AGIUpdateEmotion(EMOTION_HAPPY);
  } else if (puzzle.move_count > MAX_MOVES / 2) {
    AGIUpdateEmotion(EMOTION_CONCERNED);
  } else {
    AGIUpdateEmotion(EMOTION_CURIOUS);
  }
}

U0 PuzzleCleanup() {
  if (log_buffer) {
    MemBlkFree(log_buffer);
    log_buffer = NULL;
  }
  MemSet(&puzzle, 0, sizeof(PuzzleState));
  AGILog(LOG_NORMAL, "PsalmPuzzle cleaned up.\n");
}

U0 PsalmPuzzle() {
  PuzzleInit();
  while (puzzle.move_count < MAX_MOVES) {
    PuzzleRender();
    PuzzleUpdate();
    I64 key = KbdGetChar();
    if (key == CH_ESC) {
      PuzzleCleanup();
      return;
    }
    I64 dx = 0, dy = 0;
    switch (key) {
      case 'w': dy = -1; break;
      case 's': dy = 1; break;
      case 'a': dx = -1; break;
      case 'd': dx = 1; break;
      case ' ': // Swap with empty tile
        I64 nx = puzzle.cursor_x + dx;
        I64 ny = puzzle.cursor_y + dy;
        if (nx >= 0 && nx < GRID_SIZE && ny >= 0 && ny < GRID_SIZE) {
          if (puzzle.grid[ny][nx] == 0) {
            puzzle.grid[ny][nx] = puzzle.grid[puzzle.cursor_y][puzzle.cursor_x];
            puzzle.grid[puzzle.cursor_y][puzzle.cursor_x] = 0;
            puzzle.cursor_x = nx;
            puzzle.cursor_y = ny;
            puzzle.move_count++;
          }
        }
        break;
    }
    puzzle.cursor_x = Clamp(puzzle.cursor_x + dx, 0, GRID_SIZE - 1);
    puzzle.cursor_y = Clamp(puzzle.cursor_y + dy, 0, GRID_SIZE - 1);
  }
  GrCls;
  GrPrint(0, 0, "Puzzle Ended! Moves: %d", puzzle.move_count);
  GrUpdate;
  Sleep(2000);
  PuzzleCleanup();
}

PsalmPuzzle;
