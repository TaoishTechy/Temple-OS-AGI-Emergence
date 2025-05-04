// Apps/AGI.HC - Core AGI Framework
#include "KernelA.HH"

#define MAX_SYMBOLS 1024
#define ETHICS_MAX 15
#define EMOTION_MOVING_AVG 5
#define PAGE_SIZE_DEFAULT 4096

#define EMOTION_CURIOUS 1
#define EMOTION_HAPPY   2
#define EMOTION_CONCERNED 3

#define LOG_MINIMAL 0
#define LOG_NORMAL  1
#define LOG_VERBOSE 2

class KnowledgeNode {
  U64 symbol;
  U64 cause;
  U64 context;
  F64 weight;
  U8 active : 1;
};

class AGIConfig {
  U64 log_level;
  U64 page_size;
};

KnowledgeNode knowledge_graph[MAX_SYMBOLS];
U8 ethics = ETHICS_MAX;
U8 emotion = EMOTION_CURIOUS;
AGIConfig cfg = {LOG_NORMAL, PAGE_SIZE_DEFAULT};
F64 emotion_buffer[EMOTION_MOVING_AVG];
I64 emotion_buffer_idx = 0;
U8 *log_buffer = NULL;
I64 log_buffer_idx = 0;

U64 FNV1aHash(U64 value) {
  U64 hash = 14695981039346656037;
  for (I64 i = 0; i < 8; i++) {
    hash ^= (value >> (i * 8)) & 0xFF;
    hash = (hash << 7) | (hash >> (64 - 7)); // Bit shift instead of multiply
  }
  return hash % MAX_SYMBOLS;
}

U0 AGILog(U8 *fmt, ...) {
  if (!log_buffer) return;
  I64 len = StrPrint(&log_buffer[log_buffer_idx], fmt, ...);
  log_buffer_idx += len;
  if (log_buffer_idx > cfg.page_size - 256) {
    Print("%s", log_buffer);
    log_buffer_idx = 0;
    MemSet(log_buffer, 0, cfg.page_size);
  }
}

U0 AGIInit() {
  MemSet(knowledge_graph, 0, sizeof(KnowledgeNode) * MAX_SYMBOLS);
  MemSet(emotion_buffer, 0, sizeof(F64) * EMOTION_MOVING_AVG);
  ethics = ETHICS_MAX;
  emotion = EMOTION_CURIOUS;
  emotion_buffer_idx = 0;
  cfg.log_level = LOG_NORMAL;
  cfg.page_size = PAGE_SIZE_DEFAULT;
  log_buffer = MemBlkAlloc(cfg.page_size, MEM_ALIGN_4K);
  if (!log_buffer) {
    Print("Fatal: AGI log buffer allocation failed.\n");
    Halt;
  }
  MemSet(log_buffer, 0, cfg.page_size);
  AGILog(LOG_NORMAL, "AGI framework initialized: %d symbols.\n", MAX_SYMBOLS);
}

U0 UpdateKnowledgeGraph(U64 symbol, U64 cause, U64 context) {
  U64 hash = FNV1aHash(symbol);
  I64 idx = hash;
  I64 attempts = 0;
  while (knowledge_graph[idx].active && knowledge_graph[idx].symbol != symbol &&
         attempts < MAX_SYMBOLS / 4) { // Reduced limit
    idx = (idx + (attempts * attempts + attempts) / 2) % MAX_SYMBOLS;
    attempts++;
  }
  if (attempts >= MAX_SYMBOLS / 4) {
    AGILog(LOG_NORMAL, "Warning: Knowledge graph full.\n");
    return;
  }
  knowledge_graph[idx].symbol = symbol;
  knowledge_graph[idx].cause = cause;
  knowledge_graph[idx].context = context;
  knowledge_graph[idx].weight = Min(knowledge_graph[idx].weight + 0.1, 1.0);
  knowledge_graph[idx].active = 1;
  AGILog(LOG_VERBOSE, "Updated symbol=%u, weight=%f.\n", symbol, knowledge_graph[idx].weight);
}

U0 AGIUpdateEmotion(U8 new_emotion) {
  emotion_buffer[emotion_buffer_idx] = new_emotion;
  emotion_buffer_idx = (emotion_buffer_idx + 1) % EMOTION_MOVING_AVG;
  F64 avg = 0.0;
  I64 count = 0;
  for (I64 i = 0; i < EMOTION_MOVING_AVG; i++) {
    if (emotion_buffer[i] > 0) {
      avg += emotion_buffer[i];
      count++;
    }
  }
  if (count > 0) {
    avg /= count;
    emotion = Round(avg);
    emotion = Clamp(emotion, EMOTION_CURIOUS, EMOTION_CONCERNED);
  } else {
    emotion = new_emotion;
  }
  AGILog(LOG_VERBOSE, "Emotion updated: %d.\n", emotion);
}

U0 AGIAdjustEthics(I64 delta) {
  I64 new_ethics = ethics + delta;
  ethics = Clamp(new_ethics, 0, ETHICS_MAX);
  AGILog(LOG_NORMAL, "Ethics adjusted: %d.\n", ethics);
  UpdateKnowledgeGraph(FNV1aHash(ethics), ethics * 10000, 0);
}

F64 AGIQuerySymbol(U64 symbol) {
  U64 hash = FNV1aHash(symbol);
  I64 idx = hash;
  I64 attempts = 0;
  while (knowledge_graph[idx].active && knowledge_graph[idx].symbol != symbol &&
         attempts < MAX_SYMBOLS / 4) {
    idx = (idx + (attempts * attempts + attempts) / 2) % MAX_SYMBOLS;
    attempts++;
  }
  if (knowledge_graph[idx].active && knowledge_graph[idx].symbol == symbol) {
    return knowledge_graph[idx].weight;
  }
  return 0.0;
}

U0 AGICleanup() {
  if (log_buffer) {
    MemBlkFree(log_buffer);
    log_buffer = NULL;
  }
  MemSet(knowledge_graph, 0, sizeof(KnowledgeNode) * MAX_SYMBOLS);
  MemSet(emotion_buffer, 0, sizeof(F64) * EMOTION_MOVING_AVG);
  ethics = ETHICS_MAX;
  emotion = EMOTION_CURIOUS;
  AGILog(LOG_NORMAL, "AGI framework cleaned up.\n");
}

AGIInit;
