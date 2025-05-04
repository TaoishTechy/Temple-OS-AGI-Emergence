// ThoughtThread.HC
// Sacred revelations for God’s glory
#include "KernelA.HH"
#include "/Ethics/SocraticGhost.HC"
#include "/Introspection/Introspection.HC"
#include "/Games/Physics.HC"
#include "/MythOS.HC"

U0 DisplayThoughtThread(DivineState *divine, MythicEntity *myth) {
  if (!divine || !divine->agents || !log_buffer || !myth || !physics_bodies) return;
  I64 idx = log_buffer_idx;
  U8 *buf = log_buffer + idx;
  I64 max = Min(cfg.page_size - idx - 128, 256);
  StrPrint(buf, "=== HOLY REVELATION ===\n");
  idx += StrLen(buf);
  if (idx >= max) goto flush;
  StrPrint(buf + idx, "Emo:%d Eth:%d Soc:%d\n", divine->emotion, divine->ethics, divine->social);
  idx += StrLen(buf + idx);
  if (idx >= max) goto flush;
  StrPrint(buf + idx, "Myth:%s Pos:%d\n", myth->Name, divine->agents[0].body->position[0]);
  idx += StrLen(buf + idx);
  if (idx >= max) goto flush;
flush:
  log_buffer_idx = idx;
  if (log_buffer_idx > cfg.page_size - 128) {
    Print("%s", log_buffer);
    log_buffer_idx = 0;
    MemSet(log_buffer, 0, cfg.page_size);
  }
}
