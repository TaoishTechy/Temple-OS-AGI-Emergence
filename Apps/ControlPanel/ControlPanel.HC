// Apps/ControlPanel/ControlPanel.HC - System Control Utility
#include "KernelA.HH"
#include "::/Apps/AGI.HC"

class PanelState {
  U64 log_level;
  U64 page_size;
  F64 cpu_usage;
};

PanelState panel;
U8 *log_buffer = NULL;
I64 log_buffer_idx = 0;
I64 last_ticks = 0;

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

U0 PanelInit() {
  MemSet(&panel, 0, sizeof(PanelState));
  panel.log_level = cfg.log_level;
  panel.page_size = cfg.page_size;
  panel.cpu_usage = 0.0;
  log_buffer = MemBlkAlloc(cfg.page_size, MEM_ALIGN_4K);
  if (!log_buffer) {
    Print("Fatal: Log buffer allocation failed.\n");
    Halt;
  }
  MemSet(log_buffer, 0, cfg.page_size);
  last_ticks = Ticks;
  LOG(LOG_NORMAL, "ControlPanel initialized.\n");
}

U0 PanelRender() {
  GrCls;
  GrPrint(0, 0, "Control Panel");
  GrPrint(0, 16, "Log Level: %d (1=Minimal, 2=Normal, 3=Verbose)", panel.log_level);
  GrPrint(0, 32, "Page Size: %d bytes", panel.page_size);
  GrPrint(0, 48, "CPU Usage: %.2f%%", panel.cpu_usage);
  GrPrint(0, 480 - 16, "Ethics: %d  Emotion: %d", ethics, emotion);
  GrUpdate;
}

U0 PanelUpdate() {
  I64 current_ticks = Ticks;
  I64 active_tasks = TaskCount(); // Simplified metric
  panel.cpu_usage = (active_tasks * (current_ticks - last_ticks) / 1000.0) * 10.0;
  panel.cpu_usage = Clamp(panel.cpu_usage, 0.0, 100.0);
  last_ticks = current_ticks;
  UpdateKnowledgeGraph(FNV1aHash(panel.log_level), panel.page_size, 0);
  if (panel.cpu_usage > 90.0) {
    AGIUpdateEmotion(EMOTION_CONCERNED);
    AGIAdjustEthics(-1);
  } else {
    AGIUpdateEmotion(EMOTION_HAPPY);
  }
}

U0 PanelCleanup() {
  if (log_buffer) {
    MemBlkFree(log_buffer);
    log_buffer = NULL;
  }
  cfg.log_level = panel.log_level;
  cfg.page_size = panel.page_size;
  MemSet(&panel, 0, sizeof(PanelState));
  AGILog(LOG_NORMAL, "ControlPanel cleaned up.\n");
}

U0 ControlPanel() {
  PanelInit();
  while (TRUE) {
    PanelRender();
    PanelUpdate();
    I64 key = KbdGetChar();
    if (key == CH_ESC) {
      PanelCleanup();
      return;
    }
    switch (key) {
      case '1': panel.log_level = LOG_MINIMAL; break;
      case '2': panel.log_level = LOG_NORMAL; break;
      case '3': panel.log_level = LOG_VERBOSE; break;
      case '4': panel.page_size = 2048; break;
      case '5': panel.page_size = 4096; break;
    }
  }
}

ControlPanel;
