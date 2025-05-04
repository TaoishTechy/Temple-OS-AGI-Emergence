// PCIDetect.HC - Divine Detection of Hardware
// Probes PCI and BIOS to reveal God’s tools in silicon.

#include "/KernelA.HH"

U0 PCIDetect(HardwareState *hw) {
  I64 i, addr = 0xCF8, data = 0xCFC;
  if (!hw) return; // Divine safety
  hw->pci_count = 0;
  for (i = 0; i < MAX_PCI_DEVICES; i++) {
    OutU32(addr, 0x80000000 | (i << 11)); // PCI config
    hw->devices[i].vendor_id = InU16(data);
    hw->devices[i].device_id = InU16(data + 2);
    hw->devices[i].class_code = InU8(data + 11);
    hw->devices[i].sub_class = InU8(data + 10);
    if (hw->devices[i].vendor_id != 0xFFFF) {
      hw->pci_count++;
      if (cfg.log_level >= LOG_VERBOSE)
        Print("PCI device found: vendor=%x, class=%d\n",
              hw->devices[i].vendor_id, hw->devices[i].class_code);
    }
  }
  if (cfg.log_level >= LOG_MINIMAL)
    Print("PCI detection blessed by God’s sight\n");
}
