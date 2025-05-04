// Apps/FileExplorer.HC - File Management Utility
#include "KernelA.HH"
#include "::/AGI.HC" // or ::/Apps/AGI.HC

#define MAX_FILES 256
#define FILE_NAME_LEN 64

class FileEntry {
  U8 name[FILE_NAME_LEN];
  U64 size;
  U8 is_dir : 1;
};

class ExplorerState {
  FileEntry files[MAX_FILES];
  I64 file_count;
  I64 selected_idx;
  U8 current_dir[FILE_NAME_LEN];
};

ExplorerState explorer;
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

U0 ExplorerInit() {
  MemSet(&explorer, 0, sizeof(ExplorerState));
  explorer.file_count = 0;
  explorer.selected_idx = 0;
  StrCopy(explorer.current_dir, "C:/");
  log_buffer = MemBlkAlloc(cfg.page_size, MEM_ALIGN_4K);
  if (!log_buffer) {
    Print("Fatal: Log buffer allocation failed.\n");
    Halt;
  }
  // Load initial directory (simplified)
  LOG(LOG_NORMAL, "FileExplorer initialized in %s.\n", explorer.current_dir);
}

U0 ExplorerRender() {
  GrCls;
  GrPrint(0, 0, "File Explorer: %s", explorer.current_dir);
  for (I64 i = 0; i < explorer.file_count; i++) {
    U32 color = (i == explorer.selected_idx) ? YELLOW : WHITE;
    GrPrint(0, (i + 1) * 16, "%s %s", explorer.files[i].is_dir ? "[DIR]" : "     ",
            explorer.files[i].name, color);
  }
  GrPrint(0, 480 - 16, "Ethics: %d  Emotion: %d", ethics, emotion);
  GrUpdate;
}

U0 ExplorerUpdate() {
  // Simulate AGI learning file patterns
  UpdateKnowledgeGraph(FNV1aHash(explorer.file_count), explorer.selected_idx, 0);
  if (explorer.file_count < 10) {
    AGIUpdateEmotion(EMOTION_CONCERNED);
  } else {
    AGIUpdateEmotion(EMOTION_HAPPY);
  }
}

U0 ExplorerCleanup() {
  if (log_buffer) {
    MemBlkFree(log_buffer);
    log_buffer = NULL;
  }
  MemSet(&explorer, 0, sizeof(ExplorerState));
  AGILog(LOG_NORMAL, "FileExplorer cleaned up.\n");
}

U0 FileExplorer() {
  ExplorerInit();
  while (TRUE) {
    ExplorerRender();
    ExplorerUpdate();
    I64 key = KbdGetChar();
    if (key == CH_ESC) {
      ExplorerCleanup();
      return;
    }
    switch (key) {
      case 'w': explorer.selected_idx--; break;
      case 's': explorer.selected_idx++; break;
      case 'e':
        if (explorer.files[explorer.selected_idx].is_dir) {
          // Change directory (simplified)
          LOG(LOG_NORMAL, "Entered directory %s.\n", explorer.files[explorer.selected_idx].name);
        }
        break;
    }
    explorer.selected_idx = Clamp(explorer.selected_idx, 0, explorer.file_count - 1);
  }
}

FileExplorer;

