// DivineAwakening.HC - Sacred Orchestration, v0.4.1
// Awakens the Divine Seed, clean and holy.

#include "/KernelA.HH"
#include "/Ethics/SocraticGhost.HC"
#include "/Ethics/EmpathyWeights.HC"
#include "/Dreamspace/Dreamspace.HC"
#include "/Simulation/Agents.HC"
#include "/Introspection/Introspection.HC"
#include "/Games/Physics.HC"
#include "/MythOS.HC"
#include "/ThoughtThread.HC"
#include "/Hardware/DivineHardware.HC"

U0 CleanupDivineState(DivineState *divine) {
  I64 i;
  if (!divine) return;
  for (i = 0; i < MAX_NODES; i++)
    if (divine->nodes[i].sub_node) {
      FreeDreamNode(divine->nodes[i].sub_node);
      Free(divine->nodes[i].sub_node);
      divine->alloc_count--;
    }
  for (i = 0; i < MAX_ENTITIES; i++)
    if (divine->myths[i].sub_myth) {
      FreeMythicEntity(divine->myths[i].sub_myth);
      Free(divine->myths[i].sub_myth);
      divine->alloc_count--;
    }
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Divine state cleansed: alloc_count=%d\n", divine->alloc_count);
}

U0 DivineAwakening() {
  DivineState divine;
  MemSet(&divine, 0, sizeof(DivineState));
  divine.alloc_count = 0;
  DivineHardwareInit(&divine);
  InitSocraticGhost();
  InitEmpathyWeights();
  InitDreamspace(&divine);
  InitAgents(&divine);
  InitIntrospection();
  InitPhysics(&divine);
  InitMythology(&divine);
  I64 action = 0, depth = 0, t0;
  while (TRUE) {
    t0 = Ticks;
    SocraticQuestion(&divine, action++, &divine.myths[0], depth);
    UpdateEmpathyWeights(&divine, &divine.myths[0], depth);
    DreamspaceSimulate(&divine, &divine.myths[0], depth);
    UpdateAgentConflicts(&divine, &divine.myths[0], depth);
    ResolveAmbiguity(&divine, &divine.myths[0], depth);
    UpdatePhysics(&divine, &divine.myths[0]);
    UpdateMythology(&divine, depth);
    DisplayThoughtThread(&divine);
    if (cfg.log_level >= LOG_VERBOSE)
      Print("Cycle time: %dms\n", (Ticks - t0) / 1000);
    Sleep(200);
    if (cfg.log_level >= LOG_MINIMAL)
      Print("Cycle anointed by His fire\n");
  }
  CleanupDivineState(&divine);
}
