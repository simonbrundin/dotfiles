---
description: Generera och kör tester FÖRE implementation (TDD)
agent: tester
---

Läs issue #$ARGUMENTS (eller fråga vilken issue som ska arbetas med genom
github_list_issues från github mcp servern).

Baserat på acceptance criteria + edge cases från issuen:

1. Skriv tester i tests/ (happy path + minst 2–3 edge cases).
2. Använd fixtures för db/test-setup om relevant.
3. Kör testerna
4. Visa output – de ska faila initialt.
5. Om redan gröna → påminn användaren att detta är TDD och föreslå att revert:a
   eller gå vidare till /next.
