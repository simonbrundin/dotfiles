---
description: Skapa PR med Closes #X och verifieringsinstruktioner
agent: build
---

För issue #$ARGUMENTS:

1. Se till att tester är gröna
2. Skapa branch om ingen finn
3. Skapa PR:
   !`gh pr create --title "Titel från issue" --body "Closes #$ARGUMENTS\n\n## Verifiering\n[curl-exempel eller steg]\n..." 2>&1`
4. Generera verifieringssektion: curl-kommandon, terminal-exempel, förväntad
   output, frontend-steg om relevant.

Kopiera PR-länken när klar.
