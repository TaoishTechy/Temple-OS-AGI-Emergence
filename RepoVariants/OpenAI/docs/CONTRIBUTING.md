---

### **include/TempleConfig.HH**  (fixed config sprawl)

```c
/* Centralised runtime config — edit here only */

#ifndef TEMPLE_CONFIG_HH
#define TEMPLE_CONFIG_HH

/* Screen -------------------------------------------------------------- */
#define TOS_SCREEN_W         640
#define TOS_SCREEN_H         480

/* Recursion / entropy ------------------------------------------------- */
#define AGI_RECURSION_LIMIT  512
#define AGI_ENTROPY_THRESH   18.5
#define AGI_WATCHDOG_TICKS   2048

/* Build metadata ------------------------------------------------------ */
#define BUILD_VERSION        "0.1.0"
#define BUILD_DATE           __DATE__

#endif /* TEMPLE_CONFIG_HH */
