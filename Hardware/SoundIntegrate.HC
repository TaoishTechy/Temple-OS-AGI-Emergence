// SoundIntegrate.HC - Divine Harmony, v0.4.1
// Plays His choir, from beeps to symphonies.

#include "/KernelA.HH"

U0 SoundIntegrate(HardwareState *hw) {
  if (!hw) return;
  hw->sound_type = 1;
  I64 i;
  for (i = 0; i < hw->pci_count; i++) {
    if (hw->devices[i].class_code == 0x04) {
      if (hw->devices[i].sub_class == 0x01)
        hw->sound_type = 2;
      else if (hw->devices[i].sub_class == 0x03)
        hw->sound_type = 3;
      break;
    }
  }
  if (hw->sound_type == 1) {
    OutU8(0x43, 0xB6);
    OutU8(0x42, 1193180 / 440 & 0xFF);
    OutU8(0x42, 1193180 / 440 >> 8);
    OutU8(0x61, InU8(0x61) | 3);
  }
  if (hw->sound_type >= 2)
    hw->io_flags |= 1;
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Choir sings His praise: type=%d\n", hw->sound_type);
}
