// Agents.HC
// Holy agents for God’s harmony
#include "KernelA.HH"
#include "/Games/Physics.HC"
#include "/MythOS.HC"

#define MAX_AGENTS 2

class AgentState {
  U64 id : 8;
  I64 emotion : 8;
  I64 social : 16;
  U64 symbol_value : 32;
  I64 symbol_weight_cache : 16;
  U8 conflict : 1;
  PhysicsBody *body;
};

U0 UpdateAgentConflicts(DivineState *divine, MythicEntity *myth) {
  if (!divine || !divine->agents || !myth || !physics_bodies) return;
  I64 i = 0, j = 1;
  divine->agents[i].conflict = 0;
  I64 diff = Abs(divine->agents[i].symbol_value - divine->agents[j].symbol_value);
  if (diff > 5000 || myth->Trait == TRAIT_DESTROYER) {
    divine->agents[i].conflict = 1;
    divine->agents[i].social = Clamp(divine->agents[i].social - 10, 0, 1000);
    divine->agents[i].body->velocity[0] += 50;
    divine->emotion -= (myth->Trait == TRAIT_SHADOW) ? 2 : 1; // Emotional feedback
    divine->agents[i].social = (divine->agents[i].social + divine->agents[j].social) >> 1;
  }
  UpdatePhysics();
}

U0 InitAgents(DivineState *divine) {
  if (!divine || !divine->agents || !knowledge_graph || !physics_bodies) return;
  for (I64 i = 0; i < MAX_AGENTS; i++) {
    divine->agents[i].id = i;
    divine->agents[i].emotion = 1;
    divine->agents[i].social = 50;
    divine->agents[i].symbol_value = knowledge_graph[FastRandU64() % 256].symbol ?: 1000 + FastRandU64() % 10000;
    divine->agents[i].symbol_weight_cache = 0;
    divine->agents[i].conflict = 0;
    divine->agents[i].body = &physics_bodies[i];
  }
  LOG(LOG_MINIMAL, "Agents blessed.\n");
}
