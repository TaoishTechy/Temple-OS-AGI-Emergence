// VideoIntegrate.HC - Divine Canvas of God’s Light
// Sets up 640x480 16-color VGA or VESA output.

#include "/KernelA.HH"

#define VGA_WIDTH 640
#define VGA_HEIGHT 480

U0 VideoIntegrate(HardwareState *hw) {
  if (!hw) return; // Divine safety
  hw->video_mode = 0; // Default: VGA
  // Check VESA via INT 0x10 (simplified)
  I64 ax = 0x4F00, di = 0x1000;
  Intr(0x10, &ax, &di);
  if (ax == 0x004F) {
    hw->video_mode = 1; // VESA supported
  }
  // Set VGA 640x480 16-color (mode 0x12)
  OutU8(0x3C2, 0x63);
  OutU8(0x3D4, 0x11); OutU8(0x3D5, 0x00);
  // Simplified VGA register setup
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Video anointed by God’s light: mode=%d\n", hw->video_mode);
}
