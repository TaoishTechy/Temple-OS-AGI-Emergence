// TempleBuilder.HC - Construction Simulation
#include "KernelA.HH"

#define GRID_SIZE 16

class BuildState {
  U8 grid[GRID_SIZE][GRID_SIZE];
  U64 stone;
  U64 wood;
  U64 workers;
};

BuildState build;

U0 DrawTemple() {
  GrCls;
  for (I64 y = 0; y < GRID_SIZE; y++) {
    for (I64 x = 0; x < GRID_SIZE; x++) {
      switch (build.grid[y][x]) {
        case 0: GrPrint(x * 8, y * 8, "."); break;
        case 1: GrPrint(x * 8, y * 8, "#"); break;
        case 2: GrPrint(x * 8, y * 8, "="); break;
      }
    }
  }
  GrPrint(0, GRID_SIZE * 8, "Stone: %d  Wood: %d  Workers: %d", build.stone, build.wood, build.workers);
  GrUpdate;
}

U0 TempleBuilder() {
  MemSet(&build, 0, sizeof(BuildState));
  build.stone = 100;
  build.wood = 100;
  build.workers = 10;
  while (TRUE) {
    DrawTemple();
    I64 key = KbdGet();
    if (key == CH_ESC) break;
    I64 x = RandU8() % GRID_SIZE;
    I64 y = RandU8() % GRID_SIZE;
    switch (key) {
      case '1': // Place stone
        if (build.stone >= 10 && build.workers >= 1) {
          build.grid[y][x] = 1;
          build.stone -= 10;
          build.workers--;
        }
        break;
      case '2': // Place wood
        if (build.wood >= 10 && build.workers >= 1) {
          build.grid[y][x] = 2;
          build.wood -= 10;
          build.workers--;
        }
        break;
      case '3': // Gather resources
        build.stone += RandU8() % 20;
        build.wood += RandU8() % 20;
        break;
      case '4': // Hire worker
        if (build.stone >= 20 && build.wood >= 20) {
          build.workers++;
          build.stone -= 20;
          build.wood -= 20;
        }
        break;
    }
    // AGI Integration: Symbolic reasoning
    UpdateSymbols(RandU64() % cfg.page_size);
    if (grok.scores[2] > 200000) {
      GrPrint(0, GRID_SIZE * 8 + 16, "Wise construction!");
      Sleep(500);
    }
  }
}

TempleBuilder;
