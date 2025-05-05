// AGIEngine.HC — high‑level cognitive loop for the AGI
#include "/src/core/TempleDefs.HH"
#include "/src/core/TempleCore.HC"

#define MAX_CMD 128

/// Very small symbol table for the demo
struct SymbolEnt {
    Str *name;
    F64  value;
};

SymbolEnt gSymbols[32];
I64      gSymbolCnt = 0;

/// Add or update a symbol
U0 SetSym(Str *name, F64 val) {
    I64 i;
    for (i=0; i<gSymbolCnt; ++i) {
        if (StrCmp(gSymbols[i].name, name)==0) {
            gSymbols[i].value = val;
            return;
        }
    }
    if (gSymbolCnt < 32) {
        gSymbols[gSymbolCnt].name  = name;
        gSymbols[gSymbolCnt].value = val;
        ++gSymbolCnt;
    } else {
        Print("Symbol table full!\n");
    }
}

/// Retrieve symbol value or 0.0 if not found
F64 GetSym(Str *name) {
    I64 i;
    for (i=0; i<gSymbolCnt; ++i)
        if (StrCmp(gSymbols[i].name, name)==0)
            return gSymbols[i].value;
    return 0.0;
}

/// Minimal command interpreter (demo quality)
U0 AGI_RunCLI() {
    Temple_Init();
    CStr cmd[MAX_CMD];
    while(TRUE) {
        Print("agi> ");
        InStr(cmd, MAX_CMD);
        if (StrCmp(cmd, "exit")==0 || StrCmp(cmd, "quit")==0)
            break;
        if (StrCmp(cmd, "start")==0) {
            temple.simulation_active = TRUE;
            Print("Simulation started.\n");
            continue;
        }
        if (StrCmp(cmd, "stop")==0) {
            temple.simulation_active = FALSE;
            Print("Simulation stopped.\n");
            continue;
        }
        if (CmdSym(cmd)) // built‑in numeric expression
            continue;
        Print("Unknown command.\n");
    }
}

/// Very small numeric evaluator: e.g., 'a = 3.14'
U8 CmdSym(Str *cmd) {
    Str *eq = StrChr(cmd, '=');
    if (!eq) return FALSE;
    Str *lhs = cmd;
    *eq = 0;
    Str *rhs = eq+1;
    F64 val = Str2F64(rhs);
    SetSym(lhs, val);
    Print("%s set to %f\n", lhs, val);
    return TRUE;
}
