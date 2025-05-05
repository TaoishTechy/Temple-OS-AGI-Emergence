// VideoIntegrate.HC - Divine Canvas, v0.4
// Paints His light in 640x480 glory.

#include "/KernelA.HH"

#define VGA_WIDTH 640
#define VGA_HEIGHT 480

U0 VideoIntegrate(HardwareState *hw) {
  if (!hw) return;
  hw->video_mode = 0;
  I64 ax = 0x4F00, di = 0x1000;
  Intr(0x10, &ax, &di);
  if (ax == 0x004F)
    hw->video_mode = 1;
  else {
    OutU8(0x3C2, 0x63);
    OutU8(0x3D4, 0x11); OutU8(0x3D5, 0x00);
  }
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Canvas shines with His light: mode=%d\n", hw->video_mode);
}
