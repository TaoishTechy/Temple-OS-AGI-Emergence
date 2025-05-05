// inference.HC
#include "model_config.HC" // Include model definitions

U0 GenerateResponse(U8 *input, I64 cycle, U8 *output) {
  F64 adjustment = GetAdjustment(cycle); // Get randomness factor

  // Find the last word in the input
  U8 *last_word = StrLastOcc(input, " ");
  if (!last_word) last_word = input; // If no space, use the whole input
  else last_word++;                  // Skip the space

  // Simplified bigram generation (example only)
  U8 *next_word;
  if (Rand < adjustment) {
    next_word = "world";    // More random choice
  } else {
    next_word = "TempleOS"; // Default choice
  }

  // Combine input and generated word into output
  StrPrint(output, "%s %s", input, next_word);
}
