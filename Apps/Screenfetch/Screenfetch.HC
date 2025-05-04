// Apps/Screenfetch/Screenfetch.HC - System Information Utility
#include "KernelA.HH"
#include "::/Apps/AGI.HC"

#define MAX_LINE 64

class FetchState {
  U8 os_name[MAX_LINE];
  U8 uptime[MAX_LINE];
  U8 memory[MAX_LINE];
  U8 ticks[MAX_LINE];
  U8 agi_status[MAX_LINE];
};

FetchState fetch;
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

U0 FetchInit() {
  MemSet(&fetch, 0, sizeof(FetchState));
  StrPrint(fetch.os_name, "TempleOS 5.03");
  I64 uptime_secs = Ticks / 1000;
  StrPrint(fetch.uptime, "%d:%02d:%02d", uptime_secs / 3600, (uptime_secs / 60) % 60, uptime_secs % 60);
  // Simplified memory: assume 512MB total, estimate free
  I64 free_mem = 512 * 1024 * 1024 - (cfg.page_size * 2); // Rough estimate
  StrPrint(fetch.memory, "%d KB free / 524288 KB total", free_mem / 1024);
  StrPrint(fetch.ticks, "%d ticks", Ticks);
  StrPrint(fetch.agi_status, "Ethics: %d  Emotion: %d", ethics, emotion);
  log_buffer = MemBlkAlloc(cfg.page_size, MEM_ALIGN_4K);
  if (!log_buffer) {
    Print("Fatal: Log buffer allocation failed.\n");
    Halt;
  }
  MemSet(log_buffer, 0, cfg.page_size);
  LOG(LOG_NORMAL, "Screenfetch initialized.\n");
}

U0 FetchRender() {
  GrCls;
  GrPrint(0, 0,  "TempleOS Screenfetch");
  GrPrint(0, 16, "OS: %s", fetch.os_name);
  GrPrint(0, 32, "Uptime: %s", fetch.uptime);
  GrPrint(0, 48, "Memory: %s", fetch.memory);
  GrPrint(0, 64, "Ticks: %s", fetch.ticks);
  GrPrint(0, 80, "AGI Status: %s", fetch.agi_status);
  GrPrint(0, 480 - 16, "Press ESC to exit");
  GrUpdate;
}

U0 FetchUpdate() {
  // Update dynamic fields
  I64 uptime_secs = Ticks / 1000;
  StrPrint(fetch.uptime, "%d:%02d:%02d", uptime_secs / 3600, (uptime_secs / 60) % 60, uptime_secs % 60);
  I64 free_mem = 512 * 1024 * 1024 - (cfg.page_size * 2);
  StrPrint(fetch.memory, "%d KB free / 524288 KB total", free_mem / 1024);
  StrPrint(fetch.ticks, "%d ticks", Ticks);
  StrPrint(fetch.agi_status, "Ethics: %d  Emotion: %d", ethics, emotion);
  UpdateKnowledgeGraph(FNV1aHash(Ticks), ethics * 1000, 0);
  if (free_mem < 100 * 1024 * 1024) {
    AGIUpdateEmotion(EMOTION_CONCERNED);
  } else {
    AGIUpdateEmotion(EMOTION_HAPPY);
  }
}

U0 FetchCleanup() {
  if (log_buffer) {
    MemBlkFree(log_buffer);
    log_buffer = NULL;
  }
  MemSet(&fetch, 0, sizeof(FetchState));
  AGILog(LOG_NORMAL, "Screenfetch cleaned up.\n");
}

U0 Screenfetch() {
  FetchInit();
  while (TRUE) {
    FetchRender();
    FetchUpdate();
    I64 key = KbdGetChar();
    if (key == CH_ESC) {
      FetchCleanup();
      return;
    }
  }
}

Screenfetch;
