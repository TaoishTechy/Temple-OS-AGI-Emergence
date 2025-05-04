// Ecology.HC - Ecological Dynamics Module for TempleOS
#include "KernelA.HH"

#define GRID_SIZE 16
#define MAX_SPECIES 8
#define MAX_RESOURCES 2
#define POLLUTION_MAX 1000

#define RES_WATER 0
#define RES_SOIL  1

class Species {
  F64 population;
  F64 growth_rate;
  F64 water_need;
  F64 soil_need;
  U8 active : 1;
};

class EcoState {
  F64 resources[MAX_RESOURCES];
  F64 pollution;
  Species species[MAX_SPECIES];
};

EcoState eco;

U0 EcoInit() {
  MemSet(&eco, 0, sizeof(EcoState));
  eco.resources[RES_WATER] = 1000.0;
  eco.resources[RES_SOIL] = 1000.0;
  eco.pollution = 200.0;
  eco.species[0].population = 50.0; eco.species[0].growth_rate = 0.01; eco.species[0].water_need = 0.1; eco.species[0].soil_need = 0.2; eco.species[0].active = 1;
  eco.species[1].population = 20.0; eco.species[1].growth_rate = 0.02; eco.species[1].water_need = 0.05; eco.species[1].soil_need = 0.05; eco.species[1].active = 1;
  for (I64 i = 2; i < MAX_SPECIES; i++) {
    eco.species[i].active = 0;
  }
}

U0 EcoUpdate(F64 delta_time) {
  F64 total_water_use = 0.0;
  F64 total_soil_use = 0.0;
  for (I64 i = 0; i < MAX_SPECIES; i++) {
    if (!eco.species[i].active) continue;
    total_water_use += eco.species[i].population * eco.species[i].water_need;
    total_soil_use += eco.species[i].population * eco.species[i].soil_need;
  }
  eco.resources[RES_WATER] = Max(eco.resources[RES_WATER] - total_water_use * delta_time, 0.0);
  eco.resources[RES_SOIL] = Max(eco.resources[RES_SOIL] - total_soil_use * delta_time, 0.0);
  eco.pollution += total_water_use * 0.01 * delta_time;
  eco.pollution = Min(eco.pollution, POLLUTION_MAX);

  for (I64 i = 0; i < MAX_SPECIES; i++) {
    if (!eco.species[i].active) continue;
    F64 growth = eco.species[i].growth_rate * eco.species[i].population;
    growth *= (eco.resources[RES_WATER] / (eco.resources[RES_WATER] + 100.0));
    growth *= (eco.resources[RES_SOIL] / (eco.resources[RES_SOIL] + 100.0));
    growth *= (1.0 - eco.pollution / POLLUTION_MAX);
    eco.species[i].population += growth * delta_time;
    eco.species[i].population = Max(eco.species[i].population, 0.0);
    if (eco.species[i].population < 1.0) eco.species[i].active = 0;
  }
}

U0 EcoPlantTree(I64 species_idx) {
  if (species_idx < 0 || species_idx >= MAX_SPECIES) return;
  eco.species[species_idx].population += 10.0;
  eco.species[species_idx].active = 1;
  eco.pollution -= 20.0;
  eco.resources[RES_SOIL] -= 50.0;
  eco.resources[RES_WATER] -= 50.0;
}

U0 EcoCleanWater() {
  eco.pollution -= 50.0;
  eco.resources[RES_WATER] -= 100.0;
  eco.pollution = Max(eco.pollution, 0.0);
}

F64 EcoHealth() {
  F64 total_pop = 0.0;
  I64 active_species = 0;
  for (I64 i = 0; i < MAX_SPECIES; i++) {
    if (!eco.species[i].active) continue;
    total_pop += eco.species[i].population;
    active_species++;
  }
  return (total_pop / 1000.0) * (active_species / MAX_SPECIES) * (1.0 - eco.pollution / POLLUTION_MAX);
}

EcoInit;
