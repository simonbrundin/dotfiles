---
description: Refactor senaste kodändringar (clean code, SOLID, DRY)
agent: build
---

Analysera senaste ändringar (senaste commits eller staged filer).

1. Sätt label `refactor` på aktuell issue (ta reda på issue-nummer från branch/commits):
   !`gh issue edit <ISSUE_NR> --add-label refactor --repo simonbrundin/ai`

2. Applicera clean code: bättre namn, single responsibility, ta bort dupes.
2. Behåll 100% gröna tester – kör efter varje refactor.
3. Förklara varje förändring tydligt i svaret.

Om inget att refactor → säg det och föreslå /docs eller /pr.
