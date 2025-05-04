// Apps/HolyCanvas.HC - Graphics Visualization Tool
#include "KernelA.HH"
#include "Gr3D.HH"
#include "::/AGI.HC"

#define CANVAS_SIZE 640
#define MAX_NODES 128

class CanvasState {
  U8 canvas[CANVAS_SIZE][CANVAS_SIZE];
  I64 selected_node;
};

CanvasState canvas;
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

U0 CanvasInit() {
  MemSet(&canvas, 0, sizeof(CanvasState));
  canvas.selected_node = -1;
  log_buffer = MemBlkAlloc(cfg.page_size, MEM_ALIGN_4K);
  if (!log_buffer) {
    Print("Fatal: Log buffer allocation failed.\n");
    Halt;
  }
  LOG(LOG_NORMAL, "HolyCanvas initialized.\n");
}

U0 CanvasRender() {
  GrCls;
  // Simplified: Draw knowledge graph nodes
  for (I64 i = 0; i < MAX_NODES; i++) {
    if (!knowledge_graph[i].active) continue;
    I64 x = (i % 32) * 20;
    I64 y = (i / 32) * 20;
    GrPrint(x, y, "*", i == canvas.selected_node ? YELLOW : WHITE);
  }
  GrPrint(0, 480 - 16, "Ethics: %d  Emotion: %d", ethics, emotion);
  GrUpdate;
}

U0 CanvasUpdate() {
  if (canvas.selected_node >= 0) {
    UpdateKnowledgeGraph(FNV1aHash(canvas.selected_node), knowledge_graph[canvas.selected_node].weight * 1000, 0);
  }
}

U0 CanvasCleanup() {
  if (log_buffer) {
    MemBlkFree(log_buffer);
    log_buffer = NULL;
  }
  MemSet(&canvas, 0, sizeof(CanvasState));
  AGILog(LOG_NORMAL, "HolyCanvas cleaned up.\n");
}

U0 HolyCanvas() {
  CanvasInit();
  while (TRUE) {
    CanvasRender();
    CanvasUpdate();
    I64 key = KbdGetChar();
    if (key == CH_ESC) {
      CanvasCleanup();
      return;
    }
    switch (key) {
      case 'w': canvas.selected_node--; break;
      case 's': canvas.selected_node++; break;
    }
    canvas.selected_node = Clamp(canvas.selected_node, -1, MAX_NODES - 1);
  }
}

HolyCanvas;
