// kernel.HC: Basic TempleOS Kernel

// Constants
#define STACK_SIZE 4096
#define MAX_PROCESSES 10

// Process structure
class Process {
  I64 pid;         // Process ID
  I64 state;       // 0 = inactive, 1 = running, 2 = ready
  U8 *stack;       // Process stack
  U8 *ip;          // Instruction pointer
};

// Global variables
Process processes[MAX_PROCESSES];
I64 current_pid = 0;
U8 *mem_pool;       // Memory pool
I64 mem_size = 1024 * 1024; // 1MB pool

// Initialize memory pool
U0 InitMemory() {
  mem_pool = MAlloc(mem_size);
  "Memory initialized: %d bytes\n", mem_size;
}

// Simple memory allocation
U8 *Alloc(I64 size) {
  static U8 *next = mem_pool;
  U8 *ptr = next;
  next += size;
  if (next > mem_pool + mem_size) {
    "Out of memory!\n";
    return NULL;
  }
  return ptr;
}

// Create a process
I64 CreateProcess(U0 (*entry)()) {
  I64 i;
  for (i = 0; i < MAX_PROCESSES; i++) {
    if (processes[i].state == 0) {
      processes[i].pid = i;
      processes[i].state = 2; // Ready
      processes[i].stack = Alloc(STACK_SIZE);
      processes[i].ip = entry;
      "Process %d created\n", i;
      return i;
    }
  }
  "No process slots available!\n";
  return -1;
}

// Round-robin scheduler
U0 Scheduler() {
  while (TRUE) {
    current_pid = (current_pid + 1) % MAX_PROCESSES;
    if (processes[current_pid].state == 2) {
      processes[current_pid].state = 1;
      "Running process %d\n", current_pid;
      Sleep(100); // Simulate execution
      processes[current_pid].state = 2;
    }
  }
}

// Kernel entry point
U0 KernelMain() {
  "Kernel starting...\n";
  InitMemory();
  CreateProcess(&Shell); // Start with a shell process
  Scheduler();          // Begin scheduling
}

// Sample shell process
U0 Shell() {
  while (TRUE) {
    "Shell running...\n";
    Sleep(500);
  }
}

// Start the kernel
KernelMain;
