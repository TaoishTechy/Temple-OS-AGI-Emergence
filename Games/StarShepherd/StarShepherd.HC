// Games/StarShepherd.HC - Celestial Pattern Simulation
#include "KernelA.HH"
#include "Gr3D.HH"
#include "::/Apps/AGI.HC"
#include "::/Games/Celestial.HC"

#define MAX_STARS 64
#define MAX_TIME 1800
#define USE_3D TRUE

class StarState {
  U64 active_stars;
  F64 time_left;
  Vector3 camera_pos;
  Vector3 camera_rot;
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
  if (log_buffer_idx > cfg.page_size - 256) {
    Print("%s", log_buffer);
    log_buffer_idx = 0;
    MemSet(log_buffer, 0, cfg.page_size);
  }
}

U0 StarInit() {
  MemSet(&stars, 0, sizeof(StarState));
  stars.active_stars = 0;
  stars.time_left = MAX_TIME;
  stars.camera_pos.x = 0;
  stars.camera_pos.y = 64;
  stars.camera_pos.z = -128;
  stars.camera_rot.x = 0;
  stars.camera_rot.y = 0;
  stars.camera_rot.z = 0;
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
  if (USE_3D) {
    Gr3DCamSet(stars.camera_pos.x, stars.camera_pos.y, stars.camera_pos.z,
               stars.camera_rot.x, stars.camera_rot.y, stars.camera_rot.z);
    Gr3DCls;
    for (I64 i = 0; i < MAX_STARS; i++) {
      if (!celestial.bodies[i].active) continue;
      Gr3DMeshDraw(celestial.bodies[i].pos.x, celestial.bodies[i].pos.y, celestial.bodies[i].pos.z,
                   2, 2, 2, i == stars.selected_star ? YELLOW : WHITE);
    }
  } else {
    GrCls;
    for (I64 i = 0; i < MAX_STARS; i++) {
      if (!celestial.bodies[i].active) continue;
      I64 x = (celestial.bodies[i].pos.x + 320) / 8;
      I64 y = (celestial.bodies[i].pos.z + 240) / 8;
      if (x < 0 || x >= 640 || y < 0 || y >= 480) continue;
      GrPrint(x, y, "*", i == stars.selected_star ? YELLOW : WHITE);
    }
  }
  GrPrint(0, 480 - 16, "Time: %.1f  Stars: %d  Alignment: %.2f", stars.time_left / 60.0, stars.active_stars, stars.alignment_score);
  GrPrint(0, 480 - 32, "Ethics: %d  Emotion: %d", ethics, emotion);
  GrUpdate;
}

U0 StarUpdate(F64 delta_time) {
  CelestialUpdate(delta_time); // Batched in Celestial.HC
  stars.alignment_score = CelestialAlignment();
  stars.active_stars = 0;
  for (I64 i = 0; i < MAX_STARS; i++) {
    if (celestial.bodies[i].active) stars.active_stars++;
  }
  UpdateKnowledgeGraph(FNV1aHash(stars.alignment_score), stars.active_stars * 1000, 0);
  if (stars.active_stars > 50) {
    AGIAdjustEthics(-1);
    LOG(LOG_NORMAL, "Warning: Celestial chaos detected.\n");
  }
  ethics = Clamp(ethics, 0, ETHICS_MAX);
  static F64 prev_alignment = 0.0;
  if (stars.alignment_score < 0.3) {
    AGIUpdateEmotion(EMOTION_CONCERNED);
  } else if (stars.alignment_score > prev_alignment + 0.1) {
    AGIUpdateEmotion(EMOTION_HAPPY);
  } else {
    AGIUpdateEmotion(EMOTION_CURIOUS);
  }
  prev_alignment = stars.alignment_score;
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
      case 'w': stars.camera_pos.z += 8; break;
      case 's': stars.camera_pos.z -= 8; break;
      case 'a': stars.camera_pos.x += 8; break;
      case 'd': stars.camera_pos.x -= 8; break;
      case 'i': stars.camera_pos.y += 8; break;
      case 'k': stars.camera_pos.y -= 8; break;
      case 'j': stars.camera_rot.y += 0.1; break;
      case 'l': stars.camera_rot.y -= 0.1; break;
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
    if (ethics < 5) {
      GrPrint(0, 480 - 48, "Guide the stars with care!");
      Sleep(500);
    }
    if (emotion == EMOTION_CONCERNED) {
      GrPrint(0, 480 - 64, "The heavens falter, align them!");
      Sleep(500);
    }
  }
  if (USE_3D) Gr3DCls; else GrCls;
  GrPrint(0, 0, "Stars Aligned! Alignment: %.2f  Stars: %d", stars.alignment_score, stars.active_stars);
  GrUpdate;
  Sleep(2000);
  StarCleanup();
}

StarShepherd;

