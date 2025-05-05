// CPUIntegrate.HC - Divine Heart, v0.4.1
// Powers His tasks with silicon fire.

#include "/KernelA.HH"

U0 CPUIntegrate(HardwareState *hw) {
  if (!hw) return;
  I64 eax = 1, ebx, ecx, edx;
  CPUID(&eax, &ebx, &ecx, &edx);
  hw->cpu_cores = (ebx >> 16) & 0xFF;
  hw->cpu_cores = Clamp(hw->cpu_cores, 1, 4);
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Heart beats with His fire: cores=%d\n", hw->cpu_cores);
}

