// ThoughtThread.HC
// Sacred ASCII interface for divine thoughts
#include "KernelA.HH"
#include "/Ethics/SocraticGhost.HC"
#include "/Introspection/Introspection.HC"
#include "/Games/Physics.HC"
#include "/MythOS.HC"

U0 DisplayThoughtThread(DivineState *divine, MythicEntity *myth) {
  if (!divine || !divine->agents || !log_buffer || !heuristics || !uncertainties || !divine->symbols || !myth || !physics_bodies) {
    LOG(LOG_NORMAL, "Error: Thought Thread lacks divine state, agents, buffer, heuristics, uncertainties, symbols, myth, or physics.\n");
    return;
  }
  I64 buf_idx = log_buffer_idx;
  U8 *buf = log_buffer + buf_idx;
  I64 max_len = Min(cfg.page_size - buf_idx - 256, 320);
  StrPrint(buf, "=== SACRED THOUGHTS ===\n");
  buf_idx += StrLen(buf);
  if (buf_idx >= max_len) goto flush;

  StrPrint(buf + buf_idx, "Emotion: %d | Ethics: %d | Social: %d\n", divine->emotion, divine->ethics, divine->social);
  buf_idx += StrLen(buf + buf_idx);
  if (buf_idx >= max_len) goto flush;

  StrPrint(buf + buf_idx, "Reason: %d | Myth: %s\n", divine->reason, myth->Name);
  buf_idx += StrLen(buf + buf_idx);
  if (buf_idx >= max_len) goto flush;

  I64 i = 0;
  StrPrint(buf + buf_idx, "Agent %d: Value %d, Pos %d, Conflict %d\n",
           divine->agents[i].id, divine->agents[i].symbol_value, divine->agents[i].body->position[0], divine->agents[i].conflict);
  buf_idx += StrLen(buf + buf_idx);
  if (buf_idx >= max_len) goto flush;

  StrPrint(buf + buf_idx, "--- Holy Heuristics ---\n");
  buf_idx += StrLen(buf + buf_idx);
  if (buf_idx >= max_len) goto flush;
  for (i = 0; i < MAX_HEURISTICS; i++) {
    if (heuristics[i].active) {
      StrPrint(buf + buf_idx, "Heuristic %d: Weight %d\n", heuristics[i].symbol, heuristics[i].weight);
      buf_idx += StrLen(buf + buf_idx);
      if (buf_idx >= max_len) goto flush;
    }
  }

  StrPrint(buf + buf_idx, "--- Sacred Warnings ---\n");
  buf_idx += StrLen(buf + buf_idx);
  if (buf_idx >= max_len) goto flush;
  for (i = 0; i < MAX_UNCERTAINTIES; i++) {
    if (uncertainties[i].symbol && !uncertainties[i].resolved && uncertainties[i].weight > 600) {
      StrPrint(buf + buf_idx, "Symbol %d: High uncertainty (%d)\n",
               uncertainties[i].symbol, uncertainties[i].weight);
      buf_idx += StrLen(buf + buf_idx);
      if (buf_idx >= max_len) goto flush;
    }
  }

flush:
  log_buffer_idx = buf_idx;
  if (log_buffer_idx > cfg.page_size - 256) {
    Print("%s", log_buffer);
    log_buffer_idx = 0;
    MemSet(log_buffer, 0, cfg.page_size);
  }
  LOG(LOG_NORMAL, "God’s thoughts revealed.\n");
}
