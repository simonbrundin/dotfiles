---
description: Implementera enligt issue (kod + få tester gröna)
agent: build
---

Issue #$ARGUMENTS (eller aktuell kontext alternativt fråga efter vilken issue du
vill implementera).

Steg:

1. Läs acceptance criteria, edge cases och teknisk kontext från issue.
2. Säkerställ att det finns tester annars för /tdd
3. Implementera stegvis: en funktion/endpoint i taget.
4. Kör tester efter varje större bit
5. Fortsätt tills testerna är gröna.
6. Commit ofta med konventionella meddelanden (feat/fix/refactor):
   !`git commit -m "..."`

Följ @AGENTS.md (clean code, stateless JWT, ingen session, etc.). Visa
diff/change innan skrivning om större fil.
