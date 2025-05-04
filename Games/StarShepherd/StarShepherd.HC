// StarShepherd.HC - Celestial Pattern Simulation Game
#include "KernelA.HH"
#include "Gr3D.HH"
#include "::/AGI.HC"
#include "::/Games/Celestial.HC"

#define SPACE_SIZE  128
#define MAX_TIME    3600
#define USE_3D      TRUE

class StarState {
  U64 time_left;
  Vector3 camera_pos;
  Vector3 camera_rot;
  I64 selected_star;
  F64 alignment_score;
};

StarState star;
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

U0 StarInit() {
  MemSet(&star, 0, sizeof(StarState));
  star.time_left = MAX_TIME;
  star.camera_pos.x = 0;
  star.camera_pos.y = 0;
  star.camera_pos.z = -256;
  star.camera_rot.x = 0;
  star.camera_rot.y = 0;
  star.camera_rot.z = 0;
  star.selected_star = -1;
  CelestialInit();
  CelestialAddStar(50, 0, 0, 1.0);
  CelestialAddStar(-50, 0, 0, 1.0);
  CelestialAddStar(0, 50, 0, 1.0);
  log_buffer = MemBlkAlloc(cfg.page_size, MEM_ALIGN_4K);
  if (!log_buffer) {
    Print("Fatal: Log buffer allocation failed.\n");
    Halt;
  }
}

U0 StarRender() {
  if (USE_3D) {
    Gr3DCamSet(star.camera_pos.x, star.camera_pos.y, star.camera_pos.z,
               star.camera_rot.x, star.camera_rot.y, star.camera_rot.z);
    Gr3DCls;
    for (I64 i = 0; i < celestial.star_count; i++) {
      if (!celestial.stars[i].active) continue;
      Gr3DMeshDraw(celestial.stars[i].pos.x, celestial.stars[i].pos.y, celestial.stars[i].pos.z,
                   2, 2, 2, WHITE);
      if (i == star.selected_star) {
        Gr3DMeshWireframe(celestial.stars[i].pos.x, celestial.stars[i].pos.y, celestial.stars[i].pos.z,
                          2, 2, 2, YELLOW);
      }
    }
  } else {
    GrCls;
    for (I64 i = 0; i < celestial.star_count; i++) {
      if (!celestial.stars[i].active) continue;
      I64 x = (celestial.stars[i].pos.x + SPACE_SIZE) * 640 / (2 * SPACE_SIZE);
      I64 y = (celestial.stars[i].pos.y + SPACE_SIZE) * 480 / (2 * SPACE_SIZE);
      GrPrint(x, y, "*", WHITE);
      if (i == star.selected_star) {
        GrRect(x, y, 8, 8, YELLOW);
      }
    }
  }
  GrPrint(0, 0, "Time: %.1f  Stars: %d  Alignment: %.2f", star.time_left / 60.0, celestial.star_count, star.alignment_score);
  GrPrint(0, 16, "Ethics: %d  Emotion: %d", ethics, emotion);
  GrUpdate;
}

U0 StarUpdate(F64 delta_time) {
  CelestialUpdate(delta_time);
  CelestialCheckCollisions();
  star.alignment_score = CelestialAlignment();
  UpdateKnowledgeGraph(star.alignment_score * 100000, (star.alignment_score > 0.7) ? 100000 : 50000,
                       (star.time_left < MAX_TIME / 2) ? 1 : 0);
  I64 active_stars = 0;
  for (I64 i = 0; i < celestial.star_count; i++) {
    if (celestial.stars[i].active) active_stars++;
  }
  if (active_stars < 3 || active_stars > 20) {
    AGIAdjustEthics(-1);
    LOG(LOG_NORMAL, "Warning: Celestial disharmony detected.\n");
  }
  ethics = Clamp(ethics, 0, ETHICS_MAX);
  static F64 prev_alignment = 0.0;
  if (star.alignment_score < 0.4) {
    AGIUpdateEmotion(EMOTION_CONCERNED);
  } else if (star.alignment_score > prev_alignment + 0.1) {
    AGIUpdateEmotion(EMOTION_HAPPY);
  } else {
    AGIUpdateEmotion(EMOTION_CURIOUS);
  }
  prev_alignment = star.alignment_score;
}

U0 StarCleanup() {
  if (log_buffer) {
    MemBlkFree(log_buffer);
    log_buffer = NULL;
  }
  MemSet(&celestial, 0, sizeof(CelestialState)); // Reset without CelestialInit
  AGILog(LOG_NORMAL, "StarShepherd cleaned up.\n");
}

U0 StarShepherd() {
  StarInit();
  F64 delta_time = 1.0 / 60.0;
  while (star.time_left > 0 && star.alignment_score < 0.95) {
    StarRender();
    StarUpdate(delta_time);
    star.time_left -= 1.0;
    I64 key = KbdGetChar();
    if (key == CH_ESC) {
      StarCleanup();
      return;
    }
    switch (key) {
      case 'w': star.camera_pos.z += 8; break;
      case 's': star.camera_pos.z -= 8; break;
      case 'a': star.camera_pos.x -= 8; break;
      case 'd': star.camera_pos.x += 8; break;
      case 'i': star.camera_pos.y += 8; break;
      case 'k': star.camera_pos.y -= 8; break;
      case 'j': star.camera_rot.y += 0.1; break;
      case 'l': star.camera_rot.y -= 0.1; break;
      case '1':
        if (celestial.star_count < MAX_STARS) {
          CelestialAddStar(RandF64() * 100 - 50, RandF64() * 100 - 50, RandF64() * 100 - 50, 1.0);
        }
        break;
      case '2':
        if (star.selected_star >= 0 && celestial.stars[star.selected_star].active) {
          celestial.stars[star.selected_star].vel.x += RandF64() * 0.1 - 0.05;
          celestial.stars[star.selected_star].vel.y += RandF64() * 0.1 - 0.05;
          celestial.stars[star.selected_star].vel.z += RandF64() * 0.1 - 0.05;
        }
        break;
      case '3':
        star.selected_star = (star.selected_star + 1) % celestial.star_count;
        while (star.selected_star < celestial.star_count && !celestial.stars[star.selected_star].active) {
          star.selected_star = (star.selected_star + 1) % celestial.star_count;
        }
        if (!celestial.stars[star.selected_star].active) star.selected_star = -1;
        break;
    }
    if (ethics < 5) {
      GrPrint(0, 32, "Guide the stars with harmony!");
      Sleep(500);
    }
    if (emotion == EMOTION_CONCERNED) {
      GrPrint(0, 48, "The heavens falter, align them!");
      Sleep(500);
    }
  }
  if (USE_3D) Gr3DCls; else GrCls;
  GrPrint(0, 0, "Constellation Formed! Alignment: %.2f  Stars: %d", star.alignment_score, celestial.star_count);
  GrUpdate;
  Sleep(2000);
  StarCleanup();
}

StarShepherd;

U0 StarCleanup() {
  if (log_buffer) {
    MemBlkFree(log_buffer);
    log_buffer = NULL;
  }
  CelestialInit; // Reset celestial state
  AGILog(LOG_NORMAL, "StarShepherd cleaned up.\n");
}

U0 StarShepherd() {
  StarInit();
  F64 delta_time = 1.0 / 60.0;
  while (star.time_left > 0 && star.alignment_score < 0.95) {
    StarRender();
    StarUpdate(delta_time);
    star.time_left -= 1.0;
    I64 key = KbdGetChar(); // Replaced KbdGet
    if (key == CH_ESC) {
      StarCleanup();
      return;
    }
    switch (key) {
      case 'w': star.camera_pos.z += 8; break;
      case 's': star.camera_pos.z -= 8; break;
      case 'a': star.camera_pos.x -= 8; break;
      case 'd': star.camera_pos.x += 8; break;
      case 'i': star.camera_pos.y += 8; break;
      case 'k': star.camera_pos.y -= 8; break;
      case 'j': star.camera_rot.y += 0.1; break;
      case 'l': star.camera_rot.y -= 0.1; break;
      case '1':
        if (celestial.star_count < MAX_STARS) {
          CelestialAddStar(RandF64() * 100 - 50, RandF64() * 100 - 50, RandF64() * 100 - 50, 1.0);
        }
        break;
      case '2':
        if (star.selected_star >= 0 && celestial.stars[star.selected_star].active) {
          celestial.stars[star.selected_star].vel.x += RandF64() * 0.1 - 0.05;
          celestial.stars[star.selected_star].vel.y += RandF64() * 0.1 - 0.05;
          celestial.stars[star.selected_star].vel.z += RandF64() * 0.1 - 0.05;
        }
        break;
      case '3':
        star.selected_star = (star.selected_star + 1) % celestial.star_count;
        while (star.selected_star < celestial.star_count && !celestial.stars[star.selected_star].active) {
          star.selected_star = (star.selected_star + 1) % celestial.star_count;
        }
        if (!celestial.stars[star.selected_star].active) star.selected_star = -1;
        break;
    }
    if (ethics < 5) {
      GrPrint(0, 32, "Guide the stars with harmony!");
      Sleep(500);
    }
    if (emotion == EMOTION_CONCERNED) {
      GrPrint(0, 48, "The heavens falter, align them!");
      Sleep(500);
    }
  }
  if (USE_3D) Gr3DCls; else GrCls;
  GrPrint(0, 0, "Constellation Formed! Alignment: %.2f  Stars: %d", star.alignment_score, celestial.star_count);
  GrUpdate;
  Sleep(2000);
  StarCleanup();
}

StarShepherd;
