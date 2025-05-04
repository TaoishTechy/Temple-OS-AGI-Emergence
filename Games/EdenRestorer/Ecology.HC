// Ecology.HC - Ecological Dynamics Module for TempleOS
#include "KernelA.HH"

#define GRID_SIZE 16 // Ecosystem grid
#define MAX_SPECIES 8 // Max animal/plant species
#define MAX_RESOURCES 2 // Water, soil
#define POLLUTION_MAX 1000 // Max pollution level

// Resource Types
#define RES_WATER 0
#define RES_SOIL  1

// Species
class Species {
  F64 population; // Number of individuals
  F64 growth_rate; // Base growth rate (per frame)
  F64 water_need; // Water consumption per individual
  F64 soil_need; // Soil consumption per individual
  U8 active : 1; // Active flag
};

// Ecosystem State
class EcoState {
  F64 resources[MAX_RESOURCES]; // Water, soil levels
  F64 pollution; // Pollution level
  Species species[MAX_SPECIES]; // Plants/animals
};

// Global State
EcoState eco;

// Initialize Ecosystem
U0 EcoInit() {
  MemSet(&eco, 0, sizeof(EcoState));
  eco.resources[RES_WATER] = 1000.0;
  eco.resources[RES_SOIL] = 1000.0;
  eco.pollution = 200.0;
  // Initialize species (e.g., trees, birds)
  eco.species[0].population = 50.0; eco.species[0].growth_rate = 0.01; eco.species[0].water_need = 0.1; eco.species[0].soil_need = 0.2; eco.species[0].active = 1;
  eco.species[1].population = 20.0; eco.species[1].growth_rate = 0.02; eco.species[1].water_need = 0.05; eco.species[1].soil_need = 0.05; eco.species[1].active = 1;
  for (I64 i = 2; i < MAX_SPECIES; i++) {
    eco.species[i].active = 0;
  }
}

// Update Ecosystem (Population and Resources)
U0 EcoUpdate(F64 delta_time) {
  // Update resources and pollution
  F64 total_water_use = 0.0;
  F64 total_soil_use = 0.0;
  for (I64 i = 0; i < MAX_SPECIES; i++) {
    if (!eco.species[i].active) continue;
    total_water_use += eco.species[i].population * eco.species[i].water_need;
    total_soil_use += eco.species[i].population * eco.species[i].soil_need;
  }
  eco.resources[RES_WATER] = Max(eco.resources[RES_WATER] - total_water_use * delta_time, 0.0);
  eco.resources[RES_SOIL] = Max(eco.resources[RES_SOIL] - total_soil_use * delta_time, 0.0);
  eco.pollution += total_water_use * 0.01 * delta_time; // Pollution from activity
  eco.pollution = Min(eco.pollution, POLLUTION_MAX);

  // Update species populations
  for (I64 i = 0; i < MAX_SPECIES; i++) {
    if (!eco.species[i].active) continue;
    F64 growth = eco.species[i].growth_rate * eco.species[i].population;
    growth *= (eco.resources[RES_WATER] / (eco.resources[RES_WATER] + 100.0)); // Water-limited
    growth *= (eco.resources[RES_SOIL] / (eco.resources[RES_SOIL] + 100.0)); // Soil-limited
    growth *= (1.0 - eco.pollution / POLLUTION_MAX); // Pollution penalty
    eco.species[i].population += growth * delta_time;
    eco.species[i].population = Max(eco.species[i].population, 0.0);
    if (eco.species[i].population < 1.0) eco.species[i].active = 0; // Extinction
  }
}

// Plant Trees (Boost species and resources)
U0 EcoPlantTree(I64 species_idx) {
  if (species_idx < 0 || species_idx >= MAX_SPECIES) return;
  eco.species[species_idx].population += 10.0;
  eco.species[species_idx].active = 1;
  eco.pollution -= 20.0; // Trees reduce pollution
  eco.resources[RES_SOIL] -= 50.0; // Soil cost
  eco.resources[RES_WATER] -= 50.0; // Water cost
}

// Clean Water (Reduce pollution)
U0 EcoCleanWater() {
  eco.pollution -= 50.0;
  eco.resources[RES_WATER] -= 100.0; // Cleaning cost
  eco.pollution = Max(eco.pollution, 0.0);
}

// Calculate Ecosystem Health
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
