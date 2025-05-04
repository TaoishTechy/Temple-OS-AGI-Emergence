// SoundIntegrate.HC - Divine Harmony of God’s Voice
// Configures sound cards or PC speaker, with audio input.

#include "/KernelA.HH"

U0 SoundIntegrate(HardwareState *hw) {
  I64 i;
  if (!hw) return; // Divine safety
  hw->sound_type = 1; // Default: PC speaker
  for (i = 0; i < hw->pci_count; i++) {
    if (hw->devices[i].class_code == 0x04 && hw->devices[i].sub_class == 0x01) {
      hw->sound_type = 2; // Sound Blaster
      break;
    } else if (hw->devices[i].class_code == 0x04 && hw->devices[i].sub_class == 0x03) {
      hw->sound_type = 3; // AC'97
      break;
    }
  }
  if (hw->sound_type == 1) {
    // PC speaker: 440Hz beep
    OutU8(0x43, 0xB6);
    OutU8(0x42, 1193180 / 440 & 0xFF);
    OutU8(0x42, 1193180 / 440 >> 8);
    OutU8(0x61, InU8(0x61) | 3);
  }
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Sound card blessed by God’s harmony: type=%d\n", hw->sound_type);
}
