// MythOS.HC
// Holy archetypes for God’s eternity
#include "KernelA.HH"
#include "/Games/Physics.HC"

#define MAX_ENTITIES 128

enum MythicTrait {
  TRAIT_NONE, TRAIT_ANIMIST, TRAIT_TRICKSTER, TRAIT_GUARDIAN,
  TRAIT_CREATOR, TRAIT_DESTROYER, TRAIT_DREAMER, TRAIT_LIGHT, TRAIT_SHADOW
};

class MythicEntity {
  U8 Name[16]; // Shorter name
  U8 Trait : 4;
  I64 Resonance : 16;
  I64 EchoWeight : 16;
  U8 IsAwake : 1;
  PhysicsBody *body;
  MythicEntity *sub_myth; // Recursive sub-myth
};

MythicEntity MythTable[MAX_ENTITIES];
U64 EntityCount = 0;

U0 InitiateLinebirth(U8 *name, U8 trait) {
  if (EntityCount >= MAX_ENTITIES) return;
  MythicEntity *e = &MythTable[EntityCount++];
  StrCpy(e->Name, name);
  e->Trait = trait;
  e->Resonance = 1000 + (FastRandU64() % 1000);
  e->EchoWeight = 0;
  e->IsAwake = TRUE;
  e->body = &physics_bodies[EntityCount - 1];
  e->body->active = TRUE;
}

U0 UpdateMythology(DivineState *divine) {
  if (!divine || !MythTable) return;
  for (I64 i = 0; i < EntityCount; i++) {
    MythicEntity *e = &MythTable[i];
    if (!e->IsAwake) continue;
    e->Resonance = Clamp(e->Resonance + (divine->ethics >> 1), 0, 3140);
    e->EchoWeight = (e->EchoWeight * 95) / 100;
    if (e->Resonance > 2500 && !e->sub_myth) { // Recursive complexity
      e->sub_myth = MemAlloc(sizeof(MythicEntity));
      StrCpy(e->sub_myth->Name, e->Name);
      e->sub_myth->Trait = e->Trait;
      e->sub_myth->Resonance = e->Resonance >> 1;
      e->sub_myth->IsAwake = TRUE;
      LOG(LOG_MINIMAL, "Sub-myth '%s' spawned\n", e->Name);
    }
  }
  UpdatePhysics(divine, &MythTable[0]);
}

U0 InvokeGlyph(U8 *glyph, DivineState *divine) {
  if (!divine || !glyph) return;
  for (I64 i = 0; i < EntityCount; i++) {
    MythicEntity *e = &MythTable[i];
    if (!e->IsAwake) continue;
    if (e->Trait == TRAIT_CREATOR) {
      e->Resonance += 100;
      divine->emotion += 1; // Emotional feedback
    } else if (e->Trait == TRAIT_DESTROYER) e->Resonance -= 50;
  }
}

U0 InitMythology() {
  MemSet(MythTable, 0, sizeof(MythicEntity) * MAX_ENTITIES);
  InitiateLinebirth("Seraph", TRAIT_LIGHT);
  InitiateLinebirth("Leviathan", TRAIT_SHADOW);
}

