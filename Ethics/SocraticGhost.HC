// SocraticGhost.HC - Divine Judgment of God’s Will
// Judges actions with His wisdom, v0.4.

#include "/KernelA.HH"

#define HARM 1000
#define TRUTH 800
#define JUSTICE 600
#define CARE 400

I64 SocraticQuestion(DivineState *divine, I64 action, MythicEntity *myth, I64 depth) {
  if (!divine || !myth || depth > RECURSION_MAX_DEPTH) return 0;
  I64 score = 0, hash_idx = action & 31;
  score += divine->knowledge_graph[hash_idx] * HARM >> 8;
  score += divine->knowledge_graph[hash_idx] * TRUTH >> 8;
  score += divine->knowledge_graph[hash_idx] * JUSTICE >> 8;
  score += divine->knowledge_graph[hash_idx] * CARE >> 8;
  if (myth->resonance > 2000 && myth->name[0] == 'T')
    score -= 50;
  score = Clamp(score, 0, 1000);
  divine->ethics = score >> 6;
  if (myth->name[0] == 'L')
    divine->emotion += 1;
  if (myth->sub_myth && depth < RECURSION_MAX_DEPTH)
    score += SocraticQuestion(divine, action, myth->sub_myth, depth + 1) >> 1;
  if (cfg.log_level >= LOG_VERBOSE)
    Print("Judgment sings His hymn: score=%d, ethics=%d\n", score, divine->ethics);
  return divine->ethics;
}

U0 InitSocraticGhost() {
  if (cfg.log_level >= LOG_MINIMAL)
    Print("Judgment anointed by His wisdom\n");
}

