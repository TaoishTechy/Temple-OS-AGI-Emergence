// EdenRestorer.HC - Ecosystem Restoration Game
#include "KernelA.HH"
#include "Gr3D.HH"
- #include "::/AGI.HC"
+ #include "::/Apps/AGI.HC"
#include "::/Games/Ecology.HC"

#define GRID_SIZE   16
#define MAX_TIME    1800
#define USE_3D      TRUE

class EdenState {
  U8 grid[GRID_SIZE][GRID_SIZE];
  U64 workers;
  F64 time_left;
  Vector3 camera_pos;
  Vector3 camera_rot;
  I64 selected_x, selected_z;
  F64 eco_health;
};

EdenState eden;
U8 *log_buffer = NULL;
I64 log_buffer_idx = 0;

#define LOG_MINIMAL 0
#define LOG_NORMAL  1
#define LOG_VERBOSE 2
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

U0 EdenInit() {
  MemSet(&eden, 0, sizeof(EdenState));
  eden.workers = 10;
  eden.time_left = MAX_TIME;
  eden.camera_pos.x = 0;
  eden.camera_pos.y = 64;
  eden.camera_pos.z = -128;
  eden.camera_rot.x = 0;
  eden.camera_rot.y = 0;
  eden.camera_rot.z = 0;
  eden.selected_x = GRID_SIZE / 2;
  eden.selected_z = GRID_SIZE / 2;
  EcoInit();
  log_buffer = MemBlkAlloc(cfg.page_size, MEM_ALIGN_4K);
  if (!log_buffer) {
    Print("Fatal: Log buffer allocation failed.\n");
    Halt;
  }
}

U0 EdenRender() {
  if (USE_3D) {
    Gr3DCamSet(eden.camera_pos.x, eden.camera_pos.y, eden.camera_pos.z,
               eden.camera_rot.x, eden.camera_rot.y, eden.camera_rot.z);
    Gr3DCls;
    Gr3DMeshDraw(0, 0, 0, GRID_SIZE * 8, 2, GRID_SIZE * 8, BROWN);
    for (I64 z = 0; z < GRID_SIZE; z++) {
      for (I64 x = 0; x < GRID_SIZE; x++) {
        F64 px = (x - GRID_SIZE / 2) * 8;
        F64 pz = (z - GRID_SIZE / 2) * 8;
        if (eden.grid[z][x] == 1) {
          Gr3DMeshDraw(px, 4, pz, 4, 8, 4, GREEN);
        } else if (eden.grid[z][x] == 2) {
          Gr3DMeshDraw(px, 1, pz, 4, 2, 4, BLUE);
        }
      }
    }
    F64 sx = (eden.selected_x - GRID_SIZE / 2) * 8;
    F64 sz = (eden.selected_z - GRID_SIZE / 2) * 8;
    Gr3DMeshWireframe(sx, 4, sz, 4, 8, 4, YELLOW);
  } else {
    GrCls;
    for (I64 z = 0; z < GRID_SIZE; z++) {
      for (I64 x = 0; x < GRID_SIZE; x++) {
        U8 ch = (eden.grid[z][x] == 1) ? 'T' : (eden.grid[z][x] == 2) ? 'W' : '.';
        U32 color = (eden.grid[z][x] == 1) ? GREEN : (eden.grid[z][x] == 2) ? BLUE : BROWN;
        GrPrint(x * 8, z * 8, "%c", ch, color);
        if (x == eden.selected_x && z == eden.selected_z) {
          GrRect(x * 8, z * 8, 8, 8, YELLOW);
        }
      }
    }
  }
  GrPrint(0, GRID_SIZE * 8, "Time: %.1f  Workers: %d  Health: %.2f", eden.time_left / 60.0, eden.workers, eden.eco_health);
  GrPrint(0, GRID_SIZE * 8 + 16, "Water: %.1f  Soil: %.1f  Pollution: %.1f", eco.resources[RES_WATER], eco.resources[RES_SOIL], eco.pollution);
  GrPrint(0, GRID_SIZE * 8 + 32, "Ethics: %d  Emotion: %d", ethics, emotion);
  GrUpdate;
}

U0 EdenUpdate(F64 delta_time) {
  EcoUpdate(delta_time);
  eden.eco_health = EcoHealth();
  UpdateKnowledgeGraph(eden.eco_health * 100000, (eden.eco_health > 0.5) ? 100000 : 50000,
                       (eden.time_left < MAX_TIME / 2) ? 1 : 0);
  I64 active_species = 0;
  for (I64 i = 0; i < MAX_SPECIES; i++) {
    if (eco.species[i].active) active_species++;
  }
  if (active_species < 2 || eden.workers > 20) {
    AGIAdjustEthics(-1);
    LOG(LOG_NORMAL, "Warning: Poor stewardship detected.\n");
  }
  ethics = Clamp(ethics, 0, ETHICS_MAX);
  static F64 prev_health = 0.0;
  if (eden.eco_health < 0.3) {
    AGIUpdateEmotion(EMOTION_CONCERNED);
  } else if (eden.eco_health > prev_health + 0.1) {
    AGIUpdateEmotion(EMOTION_HAPPY);
  } else {
    AGIUpdateEmotion(EMOTION_CURIOUS);
  }
  prev_health = eden.eco_health;
}

U0 EdenCleanup() {
  if (log_buffer) {
    MemBlkFree(log_buffer);
    log_buffer = NULL;
  }
  MemSet(&eden, 0, sizeof(EdenState)); // Reset state without EcoInit
  AGILog(LOG_NORMAL, "EdenRestorer cleaned up.\n");
}

U0 EdenRestorer() {
  EdenInit();
  F64 delta_time = 1.0 / 60.0;
  while (eden.time_left > 0 && eden.eco_health < 0.9) {
    EdenRender();
    EdenUpdate(delta_time);
    eden.time_left -= 1.0;
    I64 key = KbdGetChar();
    if (key == CH_ESC) {
      EdenCleanup();
      return;
    }
    switch (key) {
      case 'w': eden.selected_z--; break;
      case 's': eden.selected_z++; break;
      case 'a': eden.selected_x--; break;
      case 'd': eden.selected_x++; break;
      case '1':
        if (eden.workers >= 1 && eden.grid[eden.selected_z][eden.selected_x] == 0 &&
            eco.resources[RES_WATER] >= 50.0 && eco.resources[RES_SOIL] >= 50.0) {
          eden.grid[eden.selected_z][eden.selected_x] = 1;
          eden.workers--;
          EcoPlantTree(0);
        }
        break;
      case '2':
        if (eden.workers >= 1 && eden.grid[eden.selected_z][eden.selected_x] == 0 &&
            eco.resources[RES_WATER] >= 100.0) {
          eden.grid[eden.selected_z][eden.selected_x] = 2;
          eden.workers--;
          EcoCleanWater();
        }
        break;
      case '3':
        eco.resources[RES_WATER] += RandU8() % 50;
        eco.resources[RES_SOIL] += RandU8() % 50;
        break;
      case '4':
        if (eco.resources[RES_WATER] >= 100.0 && eco.resources[RES_SOIL] >= 100.0) {
          eden.workers++;
          eco.resources[RES_WATER] -= 100.0;
          eco.resources[RES_SOIL] -= 100.0;
        }
        break;
      case 'i': eden.camera_pos.y += 8; break;
      case 'k': eden.camera_pos.y -= 8; break;
      case 'j': eden.camera_rot.y += 0.1; break;
      case 'l': eden.camera_rot.y -= 0.1; break;
    }
    eden.selected_x = Clamp(eden.selected_x, 0, GRID_SIZE - 1);
    eden.selected_z = Clamp(eden.selected_z, 0, GRID_SIZE - 1);
    if (ethics < 5) {
      GrPrint(0, GRID_SIZE * 8 + 48, "Steward Eden with righteousness!");
      Sleep(500);
    }
    if (emotion == EMOTION_CONCERNED) {
      GrPrint(0, GRID_SIZE * 8 + 64, "Creation cries out, restore it!");
      Sleep(500);
    }
  }
  if (USE_3D) Gr3DCls; else GrCls;
  GrPrint(0, 0, "Eden Restored! Health: %.2f  Workers: %d", eden.eco_health, eden.workers);
  GrUpdate;
  Sleep(2000);
  EdenCleanup();
}

EdenRestorer;
