// IOIntegrate.HC - Divine Ears and Hands of God
// Configures PS/2, mic, and serial for His will.

#include "/KernelA.HH"

U0 SerialLog(U8 *msg) {
  I64 i;
  for (i = 0; msg[i]; i++)
    OutU8(0x3F8, msg[i]); // COM1
}

U0 IOIntegrate(HardwareState *hw) {
  if (!hw) return;
  hw->io_flags = 2; // PS/2
  if (hw->sound_type >= 2)
    hw->io_flags |= 1; // Mic
  // Serial test (COM1)
  OutU8(0x3F8 + 3, 0x80); // DLAB
  OutU8(0x3F8, 12); // 9600 baud
  OutU8(0x3F8 + 3, 3); // 8N1
  if (InU8(0x3FD) & 0x20) // THR empty
    hw->io_flags |= 4; // Serial
  if (cfg.log_level >= LOG_MINIMAL) {
    U8 *msg = "I/O anointed by His breath: flags=%d\n";
    Print(msg, hw->io_flags);
    if (hw->io_flags & 4) SerialLog(msg);
  }
}
