// Games/Ecology.HC - Ecological Dynamics Module
#include "KernelA.HH"
#include "::/Apps/AGI.HC"

#define MAX_SPECIES 16
#define MAX_RESOURCES 2
#define RES_WATER 0
#define RES_SOIL 1

class Species {
  F64 population;
  F64 growth_rate;
  U8 active : 1;
};

class EcoState {
  Species species[MAX_SPECIES];
  F64 resources[MAX_RESOURCES];
  F64 pollution;
  F64 eco_health;
};

EcoState eco;
U8 *log_buffer = NULL;
I64 log_buffer_idx = 0;

#define LOG(level, fmt, args...) if (cfg.log_level >= level) LogBuffer(fmt, ##args)

U0 LogBuffer(U8 *fmt, ...) {
  if (!log_buffer) return;
  I64 len = StrPrint(&log_buffer[log_buffer_idx], fmt, ...);
  log_buffer_idx += len;
  if (log_buffer_idx > cfg.page_size - 256) {
    Print("%s", log_buffer);
    log_buffer_idx = 0;
    MemSet(log_buffer, 0, cfg.page_size);
  }
}

U0 EcoInit() {
  MemSet(&eco, 0, sizeof(EcoState));
  eco.resources[RES_WATER] = 100.0;
  eco.resources[RES_SOIL] = 100.0;
  eco.pollution = 0.0;
  eco.eco_health = 0.0;
  for (I64 i = 0; i < MAX_SPECIES; i++) {
    eco.species[i].population = RandF64(10.0, 50.0);
    eco.species[i].growth_rate = RandF64(0.01, 0.05);
    eco.species[i].active = 1;
  }
  log_buffer = MemBlkAlloc(cfg.page_size, MEM_ALIGN_4K);
  if (!log_buffer) {
    Print("Fatal: Log buffer allocation failed.\n");
    Halt;
  }
  MemSet(log_buffer, 0, cfg.page_size);
  LOG(LOG_NORMAL, "Ecology initialized.\n");
}

U0 EcoUpdate(F64 delta_time) {
  for (I64 i = 0; i < MAX_SPECIES; i++) {
    if (!eco.species[i].active) continue;
    F64 growth = eco.species[i].population * eco.species[i].growth_rate * delta_time;
    growth *= (eco.resources[RES_WATER] / 100.0) * (eco.resources[RES_SOIL] / 100.0);
    growth *= (1.0 - eco.pollution / 100.0);
    eco.species[i].population += growth;
    eco.species[i].population = Max(eco.species[i].population, 0.0);
    if (eco.species[i].population < 1.0) {
      eco.species[i].active = 0;
    }
    eco.resources[RES_WATER] -= growth * 0.1;
    eco.resources[RES_SOIL] -= growth * 0.05;
    eco.pollution += growth * 0.01;
  }
  eco.resources[RES_WATER] = Max(eco.resources[RES_WATER], 0.0);
  eco.resources[RES_SOIL] = Max(eco.resources[RES_SOIL], 0.0);
  eco.pollution = Clamp(eco.pollution, 0.0, 100.0);
  eco.eco_health = EcoHealth();
  LOG(LOG_VERBOSE, "Ecology updated: Health=%.2f, Pollution=%.2f.\n", eco.eco_health, eco.pollution);
}

U0 EcoPlantTree(I64 species_idx) {
  if (species_idx >= 0 && species_idx < MAX_SPECIES) {
    eco.species[species_idx].population += 10.0;
    eco.species[species_idx].active = 1;
    eco.resources[RES_WATER] -= 20.0;
    eco.resources[RES_SOIL] -= 10.0;
    eco.pollution -= 5.0;
    eco.eco_health = EcoHealth();
    LOG(LOG_NORMAL, "Planted tree, species %d, health=%.2f.\n", species_idx, eco.eco_health);
  }
}

U0 EcoCleanWater() {
  eco.resources[RES_WATER] += 50.0;
  eco.pollution -= 10.0;
  eco.eco_health = EcoHealth();
  LOG(LOG_NORMAL, "Cleaned water, health=%.2f.\n", eco.eco_health);
}

F64 EcoHealth() {
  F64 total_pop = 0.0;
  I64 active_count = 0;
  for (I64 i = 0; i < MAX_SPECIES; i++) {
    if (eco.species[i].active) {
      total_pop += eco.species[i].population;
      active_count++;
    }
  }
  F64 pop_score = active_count > 0 ? total_pop / (active_count * 100.0) : 0.0;
  F64 resource_score = (eco.resources[RES_WATER] + eco.resources[RES_SOIL]) / 200.0;
  F64 pollution_score = 1.0 - eco.pollution / 100.0;
  return Clamp(pop_score * 0.4 + resource_score * 0.4 + pollution_score * 0.2, 0.0, 1.0);
}

U0 EcoCleanup() {
  if (log_buffer) {
    MemBlkFree(log_buffer);
    log_buffer = NULL;
  }
  MemSet(&eco, 0, sizeof(EcoState));
  AGILog(LOG_NORMAL, "Ecology cleaned up.\n");
}
