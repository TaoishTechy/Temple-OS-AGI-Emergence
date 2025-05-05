// IOIntegrate.HC - Divine Ears and Hands, v0.4.1
// Listens and speaks with His grace.

#include "/KernelA.HH"

#define SERIAL_BUFFER_SIZE 32 // Was 64

U0 SerialLog(U8 *msg) {
  static U8 buffer[SERIAL_BUFFER_SIZE];
  static I64 buf_idx = 0;
  I64 i;
  for (i = 0; msg[i] && buf_idx < SERIAL_BUFFER_SIZE - 1; i++)
    buffer[buf_idx++] = msg[i];
  if (InU8(0x3FD) & 0x20) {
    for (i = 0; i < buf_idx; i++)
      OutU8(0x3F8, buffer[i]);
    buf_idx = 0;
  } else {
    FileWrite("T:/Log.DAT", buffer, buf_idx);
    buf_idx = 0;
  }
}

U0 IOIntegrate(HardwareState *hw) {
  if (!hw) return;
  hw->io_flags = 2;
  if (hw->sound_type >= 2)
    hw->io_flags |= 1;
  OutU8(0x3F8 + 3, 0x80); OutU8(0x3F8, 12); OutU8(0x3F8 + 3, 3);
  if (InU8(0x3FD) & 0x20)
    hw->io_flags |= 4;
  if (cfg.log_level >= LOG_MINIMAL)
    SerialLog("I/O anointed by His breath\n");
}
