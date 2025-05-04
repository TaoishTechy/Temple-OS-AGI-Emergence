// Games/ShepherdsQuest/ShepherdsQuest.HC - Text-Based Adventure
#include "KernelA.HH"
#include "::/Apps/AGI.HC"

#define MAX_CHOICE 4
#define MAX_TIME 1800

class QuestState {
  U64 time_left;
  U64 flock_health;
  U64 resources;
};

QuestState quest;
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

U0 QuestInit() {
  MemSet(&quest, 0, sizeof(QuestState));
  quest.time_left = MAX_TIME;
  quest.flock_health = 100;
  quest.resources = 50;
  log_buffer = MemBlkAlloc(cfg.page_size, MEM_ALIGN_4K);
  if (!log_buffer) {
    Print("Fatal: Log buffer allocation failed.\n");
    Halt;
  }
  MemSet(log_buffer, 0, cfg.page_size);
  LOG(LOG_NORMAL, "ShepherdsQuest initialized.\n");
}

U0 QuestRender() {
  GrCls;
  GrPrint(0, 0, "Shepherd's Quest: Time Left: %.1f", quest.time_left / 60.0);
  GrPrint(0, 16, "Flock Health: %d  Resources: %d", quest.flock_health, quest.resources);
  GrPrint(0, 32, "1. Search for water");
  GrPrint(0, 48, "2. Search for food");
  GrPrint(0, 64, "3. Rest");
  GrPrint(0, 80, "4. Move forward");
  GrPrint(0, 480 - 16, "Ethics: %d  Emotion: %d", ethics, emotion);
  GrUpdate;
}

U0 QuestUpdate(I64 choice) {
  switch (choice) {
    case 1:
      quest.resources += 10;
      quest.flock_health -= 5;
      break;
    case 2:
      quest.flock_health += 10;
      quest.resources -= 5;
      break;
    case 3:
      quest.flock_health += 5;
      break;
    case 4:
      quest.time_left -= 60;
      break;
  }
  quest.flock_health = Max(quest.flock_health, 0);
  quest.resources = Max(quest.resources, 0);
  UpdateKnowledgeGraph(FNV1aHash(quest.flock_health), quest.resources * 1000, 0);
  if (quest.flock_health < 20) {
    AGIAdjustEthics(-1);
    AGIUpdateEmotion(EMOTION_CONCERNED);
  } else {
    AGIUpdateEmotion(EMOTION_HAPPY);
  }
  LOG(LOG_NORMAL, "Choice: %d, Health: %d, Resources: %d.\n", choice, quest.flock_health, quest.resources);
}

U0 QuestCleanup() {
  if (log_buffer) {
    MemBlkFree(log_buffer);
    log_buffer = NULL;
  }
  MemSet(&quest, 0, sizeof(QuestState));
  AGILog(LOG_NORMAL, "ShepherdsQuest cleaned up.\n");
}

U0 ShepherdsQuest() {
  QuestInit();
  F64 delta_time = 1.0 / 60.0;
  while (quest.time_left > 0 && quest.flock_health > 0) {
    QuestRender();
    quest.time_left -= delta_time;
    I64 key = KbdGetChar();
    if (key == CH_ESC) {
      QuestCleanup();
      return;
    }
    I64 choice = 0;
    switch (key) {
      case '1': choice = 1; break;
      case '2': choice = 2; break;
      case '3': choice = 3; break;
      case '4': choice = 4; break;
    }
    if (choice > 0) {
      QuestUpdate(choice);
    }
  }
  GrCls;
  GrPrint(0, 0, "Quest Ended! Health: %d  Resources: %d", quest.flock_health, quest.resources);
  GrUpdate;
  Sleep(2000);
  QuestCleanup();
}

ShepherdsQuest;
