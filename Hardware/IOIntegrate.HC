// IOIntegrate.HC - Divine Ears and Hands of God
// Configures PS/2, audio input, and serial output.

#include "/KernelA.HH"

U0 IOIntegrate(HardwareState *hw) {
  if (!hw) return; // Divine safety
  hw->io_flags = 2; // Default: PS/2
  // Check for mic (simplified, assumes sound card)
  if (hw->sound_type >= 2) // Sound Blaster or AC'97
    hw->io_flags |= 1; // Mic enabled
  // PS/2 keyboard/mouse via ports 0x60, 0x64 (already in TempleOS)
  if (cfg.log_level >= LOG_MINIMAL)
    Print("I/O blessed by God’s ears: flags=%d\n", hw->io_flags);
}
