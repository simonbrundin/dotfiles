---
description: Fortsätt där vi var – avgör nästa steg automatiskt
agent: plan
---

Du är i en pågående workflow: Issue → TDD → Implement → Refactor → Docs → PR.

1. Läs konversationens historia och kompakterad summary.
2. Kolla aktuell branch namn, senaste commits (!`git log --oneline -5`),
   issue-status (!`gh issue view --json state -q .state` om möjligt).
3. Läs @AGENTS.md.
4. Avgör fas baserat på:
   - Issue öppen, inga tester → → TDD
   - Tester failar → → Implement
   - Tester gröna, kod ny → → Refactor
   - Refactor klar → → Docs
   - Docs uppdaterad → → PR
5. Fortsätt exakt där: utför nästa steg eller föreslå det tydligt.
6. Om osäker → fråga: "Är vi klara med [fas] eller ska jag fortsätta?"

Visa alltid vilket steg du tror vi är på innan du agerar.
