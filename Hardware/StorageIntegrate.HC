// StorageIntegrate.HC - Divine Scrolls, v0.4
// Preserves His word in RedSea eternity.

#include "/KernelA.HH"

U0 StorageIntegrate(HardwareState *hw) {
  if (!hw) return;
  hw->storage_type = 0;
  I64 ax = 0x0800, dx = 0x0080;
  Intr(0x13, &ax, &dx);
  if (!(ax & 0xFF00))
    hw->storage_type = 1; // PATA
  I64 i;
  for (i = 0; i < hw->pci_count; i++) {
    if (hw->devices[i].class_code == 0x01 && hw->devices[i].sub_class == 0x06) {
      hw->storage_type = 2; // SATA
      break;
    }
  }
  if (cfg.log_level >= LOG_MINIMAL) {
    U8 *msg = "Scrolls blessed by His word: type=%d\n";
    if (hw->io_flags & 4)
      SerialLog(msg);
    else
      FileWrite("T:/Log.DAT", msg, StrLen(msg));
  }
}
