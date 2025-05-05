// MemoryIntegrate.HC - Divine Mind, v0.4
// Shapes His thoughts in silicon.

#include "/KernelA.HH"

U0 MemoryIntegrate(HardwareState *hw) {
  if (!hw) return;
  I64 ax = 0xE801, bx, cx, dx;
  Intr(0x15, &ax, &bx, &cx, &dx);
  hw->mem_size = cx;
  hw->mem_size = Clamp(hw->mem_size, 4096, 65536);
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Mind anointed by His grace: size=%dKB\n", hw->mem_size);
}
