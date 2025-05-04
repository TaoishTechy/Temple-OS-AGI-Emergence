// Games/StarShepherd.HC - Celestial Pattern Simulation
#include "KernelA.HH"
#include "::/Apps/AGI.HC"
#include "::/Games/Celestial.HC"

#define MAX_STARS 32 // Reduced from 64
#define MAX_TIME 1800

class StarState {
  U64 active_stars;
  F64 time_left;
  I64 selected_star;
  F64 alignment_score;
};

StarState stars;
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

U0 StarInit() {
  MemSet(&stars, 0, sizeof(StarState));
  stars.active_stars = 0;
  stars.time_left = MAX_TIME;
  stars.selected_star = -1;
  stars.alignment_score = 0.0;
  CelestialInit();
  log_buffer = MemBlkAlloc(cfg.page_size, MEM_ALIGN_4K);
  if (!log_buffer) {
    Print("Fatal: Log buffer allocation failed.\n");
    Halt;
  }
  MemSet(log_buffer, 0, cfg.page_size);
  LOG(LOG_NORMAL, "StarShepherd initialized.\n");
}

U0 StarRender() {
  GrCls;
  for (I64 i = 0; i < MAX_STARS; i++) {
    if (!celestial.bodies[i].active) continue;
    I64 x = (celestial.bodies[i].pos.x + 320) / 16;
    I64 y = (celestial.bodies[i].pos.z + 240) / 16;
    if (x < 0 || x >= 640 || y < 0 || y >= 480) continue;
    GrPrint(x, y, "*", i == stars.selected_star ? YELLOW : WHITE);
  }
  GrPrint(0, 480 - 16, "Time: %.1f  Stars: %d  Alignment: %.2f", stars.time_left / 60.0, stars.active_stars, stars.alignment_score);
  GrPrint(0, 480 - 32, "Ethics: %d  Emotion: %d", ethics, emotion);
  GrUpdate;
}

U0 StarUpdate(F64 delta_time) {
  CelestialUpdate(delta_time);
  stars.alignment_score = CelestialAlignment();
  stars.active_stars = 0;
  for (I64 i = 0; i < MAX_STARS; i++) {
    if (celestial.bodies[i].active) stars.active_stars++;
  }
  UpdateKnowledgeGraph(FNV1aHash(stars.alignment_score), stars.active_stars * 1000, 0);
  if (stars.alignment_score < 0.3) {
    AGIUpdateEmotion(EMOTION_CONCERNED);
    AGIAdjustEthics(-1);
  } else if (stars.alignment_score > 0.7) {
    AGIUpdateEmotion(EMOTION_HAPPY);
    AGIAdjustEthics(1);
  } else {
    AGIUpdateEmotion(EMOTION_CURIOUS);
  }
}

U0 StarCleanup() {
  if (log_buffer) {
    MemBlkFree(log_buffer);
    log_buffer = NULL;
  }
  MemSet(&stars, 0, sizeof(StarState));
  CelestialCleanup();
  AGILog(LOG_NORMAL, "StarShepherd cleaned up.\n");
}

U0 StarShepherd() {
  StarInit();
  F64 delta_time = 1.0 / 60.0;
  while (stars.time_left > 0 && stars.alignment_score < 0.9) {
    StarRender();
    StarUpdate(delta_time);
    stars.time_left -= delta_time;
    I64 key = KbdGetChar();
    if (key == CH_ESC) {
      StarCleanup();
      return;
    }
    switch (key) {
      case '1':
        if (stars.active_stars < MAX_STARS) {
          CelestialAddBody(RandF64(-100, 100), RandF64(-100, 100), RandF64(-100, 100),
                           RandF64(0.1, 1.0), 2, 2, 2);
          stars.active_stars++;
        }
        break;
      case '2':
        if (stars.selected_star >= 0 && stars.selected_star < MAX_STARS &&
            celestial.bodies[stars.selected_star].active) {
          celestial.bodies[stars.selected_star].vel.x += RandF64(-0.1, 0.1);
          celestial.bodies[stars.selected_star].vel.y += RandF64(-0.1, 0.1);
          celestial.bodies[stars.selected_star].vel.z += RandF64(-0.1, 0.1);
        }
        break;
      case '3': stars.selected_star++; break;
    }
    stars.selected_star = Clamp(stars.selected_star, -1, MAX_STARS - 1);
  }
  GrCls;
  GrPrint(0, 0, "Stars Aligned! Alignment: %.2f  Stars: %d", stars.alignment_score, stars.active_stars);
  GrUpdate;
  Sleep(2000);
  StarCleanup();
}

StarShepherd;
