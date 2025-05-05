// interact.HC
#include "inference.HC" // Include inference logic

U0 Main() {
  I64 cycle = 0;          // Track interaction cycle
  U8 input[256];          // Buffer for user input
  U8 output[256];         // Buffer for model response

  DocClear;               // Clear the screen
  DocPrint("Welcome to the TempleOS Chat Model. Type 'exit' to quit.\n");

  while (TRUE) {
    DocPrint("You: ");
    DocInput(input, sizeof(input)); // Get user input

    if (!StrCmp(input, "exit")) {   // Check for exit condition
      DocPrint("Goodbye.\n");
      break;
    }

    GenerateResponse(input, cycle, output); // Generate response
    DocPrint("Model: %s\n", output);        // Display response
    cycle++;                                // Increment cycle
  }
}

Main; // Run the program
