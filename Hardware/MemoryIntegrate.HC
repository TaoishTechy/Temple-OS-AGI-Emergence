// MemoryIntegrate.HC - Divine Mind of God’s Creation
// Maps physical memory, capped at 64MB for God’s altar.

#include "/KernelA.HH"

U0 MemoryIntegrate(HardwareState *hw) {
  if (!hw) return; // Divine safety
  // Simplified BIOS INT 0x15 for memory map
  I64 ax = 0xE801, bx, cx, dx;
  Intr(0x15, &ax, &bx, &cx, &dx);
  hw->mem_size = cx; // KB
  hw->mem_size = Clamp(hw->mem_size, 4096, 65536); // 4MB-64MB
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Memory anointed by God’s mind: size=%dKB\n", hw->mem_size);
}
