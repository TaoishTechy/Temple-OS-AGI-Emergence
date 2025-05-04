// PsalmPuzzle.HC - Biblical Tile-Matching Game
#include "KernelA.HH"

#define GRID_SIZE 8
#define SYMBOL_COUNT 16

class GameState {
  U8 grid[GRID_SIZE][GRID_SIZE];
  U64 score;
  U64 moves;
  U8 selected_x;
  U8 selected_y;
};

GameState game;
U8 symbols[SYMBOL_COUNT] = {'α', 'β', 'γ', 'δ', 'ε', 'ζ', 'η', 'θ', 'ι', 'κ', 'λ', 'μ', 'ν', 'ξ', 'ο', 'π'};

U0 DrawGrid() {
  GrCls;
  for (I64 y = 0; y < GRID_SIZE; y++) {
    for (I64 x = 0; x < GRID_SIZE; x++) {
      GrPrint(x * 8, y * 16, "%c", symbols[game.grid[y][x]]);
      if (x == game.selected_x && y == game.selected_y) {
        GrRect(x * 8, y * 16, 8, 16, YELLOW);
      }
    }
  }
  GrPrint(0, GRID_SIZE * 16, "Score: %d  Moves: %d", game.score, game.moves);
  GrUpdate;
}

U0 CheckMatches() {
  for (I64 y = 0; y < GRID_SIZE; y++) {
    for (I64 x = 0; x < GRID_SIZE - 2; x++) {
      if (game.grid[y][x] == game.grid[y][x+1] && game.grid[y][x] == game.grid[y][x+2]) {
        game.score += 100;
        game.grid[y][x] = RandU8() % SYMBOL_COUNT;
        game.grid[y][x+1] = RandU8() % SYMBOL_COUNT;
        game.grid[y][x+2] = RandU8() % SYMBOL_COUNT;
      }
    }
  }
  for (I64 x = 0; x < GRID_SIZE; x++) {
    for (I64 y = 0; y < GRID_SIZE - 2; y++) {
      if (game.grid[y][x] == game.grid[y+1][x] && game.grid[y][x] == game.grid[y+2][x]) {
        game.score += 100;
        game.grid[y][x] = RandU8() % SYMBOL_COUNT;
        game.grid[y+1][x] = RandU8() % SYMBOL_COUNT;
        game.grid[y+2][x] = RandU8() % SYMBOL_COUNT;
      }
    }
  }
}

U0 PsalmPuzzle() {
  MemSet(&game, 0, sizeof(GameState));
  for (I64 y = 0; y < GRID_SIZE; y++) {
    for (I64 x = 0; x < GRID_SIZE; x++) {
      game.grid[y][x] = RandU8() % SYMBOL_COUNT;
    }
  }
  while (TRUE) {
    DrawGrid();
    CheckMatches();
    I64 key = KbdGet();
    if (key == CH_ESC) break;
    switch (key) {
      case 'w': if (game.selected_y > 0) game.selected_y--; break;
      case 's': if (game.selected_y < GRID_SIZE - 1) game.selected_y++; break;
      case 'a': if (game.selected_x > 0) game.selected_x--; break;
      case 'd': if (game.selected_x < GRID_SIZE - 1) game.selected_x++; break;
      case CH_SPACE:
        if (game.selected_x < GRID_SIZE - 1) {
          U8 temp = game.grid[game.selected_y][game.selected_x];
          game.grid[game.selected_y][game.selected_x] = game.grid[game.selected_y][game.selected_x+1];
          game.grid[game.selected_y][game.selected_x+1] = temp;
          game.moves++;
        }
        break;
    }
    // AGI Integration: Ethical feedback
    if (grok.ethics < 5) {
      GrPrint(0, GRID_SIZE * 16 + 16, "Walk in righteousness!");
      Sleep(500);
    }
  }
}

PsalmPuzzle;
