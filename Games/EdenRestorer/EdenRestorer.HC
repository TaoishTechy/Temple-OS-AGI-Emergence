// Games/EdenRestorer.HC - Ecological Restoration Simulation
#include "KernelA.HH"
#include "::/Apps/AGI.HC"
#include "::/Games/Ecology.HC"

#define MAX_MOVES 100

class EdenState {
  I64 move_count;
  F64 eco_health;
};

EdenState eden;
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

U0 EdenInit() {
  MemSet(&eden, 0, sizeof(EdenState));
  eden.move_count = 0;
  eden.eco_health = 0.0;
  EcoInit();
  log_buffer = MemBlkAlloc(cfg.page_size, MEM_ALIGN_4K);
  if (!log_buffer) {
    Print("Fatal: Log buffer allocation failed.\n");
    Halt;
  }
  MemSet(log_buffer, 0, cfg.page_size);
  LOG(LOG_NORMAL, "EdenRestorer initialized.\n");
}

U0 EdenRender() {
  GrCls;
  GrPrint(0, 0, "Eden Restorer: Moves: %d", eden.move_count);
  GrPrint(0, 16, "Eco Health: %.2f", eden.eco_health);
  for (I64 i = 0; i < MAX_SPECIES; i++) {
    if (eco.species[i].active) {
      GrPrint(0, 32 + i * 16, "Species %d: %.1f", i, eco.species[i].population);
    }
  }
  GrPrint(0, 32 + MAX_SPECIES * 16, "Water: %.1f  Soil: %.1f  Pollution: %.1f",
          eco.resources[RES_WATER], eco.resources[RES_SOIL], eco.pollution);
  GrPrint(0, 480 - 16, "Ethics: %d  Emotion: %d", ethics, emotion);
  GrUpdate;
}

U0 EdenUpdate(F64 delta_time) {
  EcoUpdate(delta_time);
  eden.eco_health = EcoHealth();
  eden.move_count++;
  UpdateKnowledgeGraph(FNV1aHash(eden.eco_health), eden.move_count * 1000, 0);
  if (eden.eco_health < 0.3) {
    AGIUpdateEmotion(EMOTION_CONCERNED);
    AGIAdjustEthics(-1);
  } else if (eden.eco_health > 0.7) {
    AGIUpdateEmotion(EMOTION_HAPPY);
    AGIAdjustEthics(1);
  } else {
    AGIUpdateEmotion(EMOTION_CURIOUS);
  }
}

U0 EdenCleanup() {
  if (log_buffer) {
    MemBlkFree(log_buffer);
    log_buffer = NULL;
  }
  MemSet(&eden, 0, sizeof(EdenState));
  EcoCleanup();
  AGILog(LOG_NORMAL, "EdenRestorer cleaned up.\n");
}

U0 EdenRestorer() {
  EdenInit();
  F64 delta_time = 1.0 / 60.0;
  while (eden.move_count < MAX_MOVES && eden.eco_health < 0.9) {
    EdenRender();
    EdenUpdate(delta_time);
    I64 key = KbdGetChar();
    if (key == CH_ESC) {
      EdenCleanup();
      return;
    }
    switch (key) {
      case '1': EcoPlantTree(RandU8() % MAX_SPECIES); break;
      case '2': EcoCleanWater(); break;
    }
  }
  GrCls;
  GrPrint(0, 0, "Eden Restored! Health: %.2f  Moves: %d", eden.eco_health, eden.move_count);
  GrUpdate;
  Sleep(2000);
  EdenCleanup();
}

EdenRestorer;
