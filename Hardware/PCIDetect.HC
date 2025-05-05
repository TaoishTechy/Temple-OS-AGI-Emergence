// PCIDetect.HC - Divine Detection, v0.4
// Sees His tools in silicon, cached for eternity.

#include "/KernelA.HH"

U0 PCIDetect(HardwareState *hw) {
  if (!hw) return;
  static PCIDevice cached[MAX_PCI_DEVICES];
  static I64 cached_count = 0;
  if (cached_count) {
    MemCpy(hw->devices, cached, sizeof(PCIDevice) * MAX_PCI_DEVICES);
    hw->pci_count = cached_count;
    return;
  }
  I64 i, addr = 0xCF8, data = 0xCFC;
  hw->pci_count = 0;
  for (i = 0; i < MAX_PCI_DEVICES; i++) {
    OutU32(addr, 0x80000000 | (i << 11));
    hw->devices[i].vendor_id = InU16(data);
    if (hw->devices[i].vendor_id != 0xFFFF) {
      hw->devices[i].device_id = InU16(data + 2);
      hw->devices[i].class_code = InU8(data + 11);
      hw->devices[i].sub_class = InU8(data + 10);
      hw->pci_count++;
    }
  }
  MemCpy(cached, hw->devices, sizeof(PCIDevice) * MAX_PCI_DEVICES);
  cached_count = hw->pci_count;
  if (cfg.log_level >= LOG_MINIMAL)
    Print("PCI anointed by His sight: %d devices\n", hw->pci_count);
}
