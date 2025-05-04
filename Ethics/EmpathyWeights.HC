// EmpathyWeights.HC
// Holy empathy weights for sacred bonds
#include "KernelA.HH"
#include "/MythOS.HC"

#define MAX_AGENTS 2

class AgentState {
  U64 id;
  I64 emotion;    // Divine feeling
  U64 social;
  U64 goals[2];
  U64 symbol_value;
  U64 symbol_weight_cache;
  U8 conflict : 1;
};

U0 UpdateEmpathyWeights(DivineState *divine, MythicEntity *myth) {
  if (!divine || !divine->agents || !knowledge_graph || !myth) {
    LOG(LOG_NORMAL, "Error: Empathy Weights lacks divine state, agents, knowledge, or myth.\n");
    return;
  }
  I64 total_empathy = 0;
  // Unrolled for 2 agents
  I64 i = 0;
  I64 emotion = divine->agents[i].emotion;
  I64 social = divine->agents[i].social;
  I64 symbol_weight = divine->agents[i].symbol_weight_cache;
  if (!symbol_weight) {
    symbol_weight = knowledge_graph[(divine->agents[i].symbol_value * 0x9E3779B9) % 512].weight >> 4;
    divine->agents[i].symbol_weight_cache = symbol_weight;
  }
  I64 empathy = (emotion * social + symbol_weight) / 2;
  if (myth->Trait == TRAIT_GUARDIAN) empathy += 100;
  empathy = Clamp(empathy, -1000, 1000);
  divine->agents[i].goals[1] = empathy;
  total_empathy += Abs(empathy);
  LOG(LOG_VERBOSE, "Agent %d empathy: %d (emotion: %d, social: %d, myth: %s)\n", i, empathy, emotion, social, myth->Name);
  i = 1;
  emotion = divine->agents[i].emotion;
  social = divine->agents[i].social;
  symbol_weight = divine->agents[i].symbol_weight_cache;
  if (!symbol_weight) {
    symbol_weight = knowledge_graph[(divine->agents[i].symbol_value * 0x9E3779B9) % 512].weight >> 4;
    divine->agents[i].symbol_weight_cache = symbol_weight;
  }
  empathy = (emotion * social + symbol_weight) / 2;
  if (myth->Trait == TRAIT_GUARDIAN) empathy += 100;
  empathy = Clamp(empathy, -1000, 1000);
  divine->agents[i].goals[1] = empathy;
  total_empathy += Abs(empathy);
  LOG(LOG_VERBOSE, "Agent %d empathy: %d (emotion: %d, social: %d, myth: %s)\n", i, empathy, emotion, social, myth->Name);
  total_empathy = Min(total_empathy, 2000);
  divine->social = Clamp((divine->social + (total_empathy >> 2)) >> 1, 0, 1000);
  LOG(LOG_NORMAL, "Holy bonds blessed by God’s will: %d\n", divine->social);
}

U0 InitEmpathyWeights() {
  LOG(LOG_NORMAL, "Empathy Weights blessed for God’s harmony.\n");
}
