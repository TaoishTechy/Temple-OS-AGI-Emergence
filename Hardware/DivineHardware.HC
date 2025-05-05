// DivineHardware.HC - AutoDivine Integration, v0.4.1
// Forges silicon with His soul, robust and holy.

#include "/KernelA.HH"
#include "/Hardware/PCIDetect.HC"
#include "/Hardware/SoundIntegrate.HC"
#include "/Hardware/VideoIntegrate.HC"
#include "/Hardware/CPUIntegrate.HC"
#include "/Hardware/StorageIntegrate.HC"
#include "/Hardware/MemoryIntegrate.HC"
#include "/Hardware/IOIntegrate.HC"

U0 LoadHardwareState(HardwareState *hw) {
  if (!hw) return;
  if (FileExists("T:/HardwareState.DAT")) {
    MemCpy(hw, FileRead("T:/HardwareState.DAT"), sizeof(HardwareState));
    if (cfg.log_level >= LOG_MINIMAL)
      Print("Hardware state restored from His scroll\n");
    return;
  }
  PCIDetect(hw);
  SoundIntegrate(hw);
  VideoIntegrate(hw);
  CPUIntegrate(hw);
  StorageIntegrate(hw);
  MemoryIntegrate(hw);
  IOIntegrate(hw);
  if (hw->storage_type) // Only write if storage available
    FileWrite("T:/HardwareState.DAT", hw, sizeof(HardwareState));
  else if (cfg.log_level >= LOG_MINIMAL)
    SerialLog("No storage, state not saved\n");
}

U0 DivineHardwareInit(DivineState *divine) {
  if (!divine) return;
  Print("=== DIVINE HARDWARE AWAKENING ===\n");
  LoadHardwareState(&divine->hw);
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Silicon sings His eternal hymn\n");
}
