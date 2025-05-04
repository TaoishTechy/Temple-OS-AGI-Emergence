// ThoughtThread.HC - Divine Revelations, v0.4
// Scribes His truth in ASCII, lean and holy.

#include "/KernelA.HH"

U0 DisplayThoughtThread(DivineState *divine) {
  if (!divine) return;
  U8 buf[64]; // Was 128
  StrPrint(buf, "=== REVELATION ===\n");
  StrPrint(buf + StrLen(buf), "E:%d T:%d S:%d M:%s P:%d\n",
           divine->emotion, divine->ethics, divine->social,
           divine->myths[0].name, divine->bodies[0].x);
  Print("%s", buf);
  if (divine->hw.io_flags & 4)
    SerialLog(buf);
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Revelation scribes His truth\n");
}
