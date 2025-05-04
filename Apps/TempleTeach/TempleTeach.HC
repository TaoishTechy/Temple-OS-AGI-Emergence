// Apps/TempleTeach/TempleTeach.HC - Educational Tool
#include "KernelA.HH"
#include "::/Apps/AGI.HC"

#define MAX_ANSWER 64
#define MAX_LESSON 256
#define MAX_LESSONS 3

class TeachState {
  U8 lesson[MAX_LESSON];
  U8 answer[MAX_ANSWER];
  I64 lesson_idx;
};

TeachState teach;
U8 *log_buffer = NULL;
I64 log_buffer_idx = 0;

U8 *lessons[MAX_LESSONS] = {
  "Lesson 1: Write 'U0 Main() { Print(\"Hello, World!\"); }'",
  "Lesson 2: Write 'I64 x = 5; Print(\"x=%d\", x);'",
  "Lesson 3: Write 'U0 Loop() { for (I64 i=0; i<3; i++) Print(\"%d\", i); }'"
};

U8 *answers[MAX_LESSONS] = {
  "U0 Main() { Print(\"Hello, World!\"); }",
  "I64 x = 5; Print(\"x=%d\", x);",
  "U0 Loop() { for (I64 i=0; i<3; i++) Print(\"%d\", i); }"
};

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

U0 TeachInit() {
  MemSet(&teach, 0, sizeof(TeachState));
  teach.lesson_idx = 0;
  StrCopy(teach.lesson, lessons[teach.lesson_idx]);
  log_buffer = MemBlkAlloc(cfg.page_size, MEM_ALIGN_4K);
  if (!log_buffer) {
    Print("Fatal: Log buffer allocation failed.\n");
    Halt;
  }
  MemSet(log_buffer, 0, cfg.page_size);
  LOG(LOG_NORMAL, "TempleTeach initialized.\n");
}

U0 TeachRender() {
  GrCls;
  GrPrint(0, 0, "TempleTeach: Lesson %d", teach.lesson_idx + 1);
  GrPrint(0, 16, "%s", teach.lesson);
  GrPrint(0, 32, "Your Answer: %s", teach.answer);
  GrPrint(0, 480 - 16, "Ethics: %d  Emotion: %d", ethics, emotion);
  GrUpdate;
}

U0 TeachUpdate(U8 *answer) {
  Bool correct = StrMatch(answer, answers[teach.lesson_idx]);
  UpdateKnowledgeGraph(FNV1aHash(teach.lesson_idx), correct ? 100000 : 50000, 0);
  AGIUpdateEmotion(correct ? EMOTION_HAPPY : EMOTION_CONCERNED);
  StrCopy(teach.answer, answer);
  if (correct && teach.lesson_idx < MAX_LESSONS - 1) {
    teach.lesson_idx++;
    StrCopy(teach.lesson, lessons[teach.lesson_idx]);
  }
  LOG(LOG_NORMAL, "Answer: %s, Correct: %d.\n", answer, correct);
}

U0 TeachCleanup() {
  if (log_buffer) {
    MemBlkFree(log_buffer);
    log_buffer = NULL;
  }
  MemSet(&teach, 0, sizeof(TeachState));
  AGILog(LOG_NORMAL, "TempleTeach cleaned up.\n");
}

U0 TempleTeach() {
  TeachInit();
  U8 answer[MAX_ANSWER];
  while (TRUE) {
    TeachRender();
    GrPrint(0, 48, "Enter answer (or ESC to exit):");
    StrGet(answer, MAX_ANSWER - 1);
    if (answer[0] == CH_ESC || answer[0] == 0) {
      TeachCleanup();
      return;
    }
    TeachUpdate(answer);
  }
}

TempleTeach;
