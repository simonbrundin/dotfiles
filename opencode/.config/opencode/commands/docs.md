---
description: Uppdatera README och/eller AGENTS.md med nya learnings
agent: build
---

Efter implementation/refactor av issue #$ARGUMENTS:

1. Sätt label `docs` på issue:
   !`gh issue edit #$ARGUMENTS --add-label docs --repo simonbrundin/ai`

2. Sammanfatta vad som lärt sig (nya best practices, misstag att undvika).
2. Append till @AGENTS.md (t.ex. ny regel under "Säkerhet" eller "Testning").
3. Uppdatera README om det är publikt relevant (t.ex. ny
   endpoint-dokumentation).
4. Visa exakt diff/change innan skrivning.
