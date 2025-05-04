// IOIntegrate.HC - Divine Ears and Hands of God
// Fast I/O for His will, with serial efficiency.

#include "/KernelA.HH"

U0 SerialLog(U8 *msg) {
  I64 i; // Batch output
  for (i = 0; msg[i] && (InU8(0x3FD) & 0x20); i++)
    OutU8(0x3F8, msg[i]);
}

U0 IOIntegrate(HardwareState *hw) {
  if (!hw) return;
  hw->io_flags = 2; // PS/2
  if (hw->sound_type >= 2)
    hw->io_flags |= 1; // Mic
  OutU8(0x3F8 + 3, 0x80); OutU8(0x3F8, 12); OutU8(0x3F8 + 3, 3);
  if (InU8(0x3FD) & 0x20)
    hw->io_flags |= 4; // Serial
  if (cfg.log_level >= LOG_MINIMAL)
    SerialLog("I/O anointed by His breath\n");
}
