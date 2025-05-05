// AGIEngine.HC — core interpreter for Temple‑AGI
// ------------------------------------------------
// Public API:
//   void AGI_Init();
//   void AGI_RunPrompt();
// ------------------------------------------------

#include "/include/TempleDefs.HH"
#include "/include/TempleConfig.HH"

// =================================================
//  Internal symbol table
// =================================================
typedef struct {
    Str name;
    F64 value;
} Symbol;

static Symbol symTab[256];
static U64    symCount = 0;

// -------------------------------------------------
//  Add or update a symbol
// -------------------------------------------------
static void PutSymbol(Str name, F64 val) {
    // Linear search is fine (<256)
    for (U64 i=0;i<symCount;i++)
        if (!StrCmp(symTab[i].name,name)) { symTab[i].value = val; return; }
    symTab[symCount++] = {name,val};
}

// -------------------------------------------------
//  Parse a single user command
// -------------------------------------------------
static void Parse(Str cmd) {
    // Very trivial parser: `name = expr` or expression
    // TODO: replace with Pratt parser when needed
    Str l,r;
    if (Split(cmd,'=',&l,&r)) { PutSymbol(l, atof(r)); return; }
    Print("%f\n", atof(cmd));
}

// -------------------------------------------------
public void AGI_Init() {
    symCount = 0;
    PutSymbol("pi", 3.1415926535);
}

public void AGI_RunPrompt() {
    Str buf[128];
    while (true) {
        Print("agi> ");
        Gets(buf, sizeof(buf));
        if (!StrCmp(buf,"quit")) break;
        Parse(buf);
    }
}
