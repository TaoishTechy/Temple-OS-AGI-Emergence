// StorageIntegrate.HC - Divine Scrolls of God’s Word
// Detects PATA/SATA drives, formats RedSea for eternity.

#include "/KernelA.HH"

U0 StorageIntegrate(HardwareState *hw) {
  if (!hw) return; // Divine safety
  hw->storage_type = 0; // Default: none
  // Check INT 0x13 for drives
  I64 ax = 0x0800, dx = 0x0080;
  Intr(0x13, &ax, &dx);
  if (!(ax & 0xFF00)) {
    hw->storage_type = 1; // PATA
  }
  // Check PCI for SATA
  I64 i;
  for (i = 0; i < hw->pci_count; i++) {
    if (hw->devices[i].class_code == 0x01 && hw->devices[i].sub_class == 0x06) {
      hw->storage_type = 2; // SATA
      break;
    }
  }
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Storage blessed by God’s scrolls: type=%d\n", hw->storage_type);
}
