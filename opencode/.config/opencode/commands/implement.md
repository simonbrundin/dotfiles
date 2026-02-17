---
description: Implementera enligt issue med TDD (Red, Green, Refactor)
agent: build
---

Ifall $ARGUMENTS inte innehåller någon siffra vill jag att du söker efter öppna
issues i github i repot och frågar vilket jag vill arbeta med.

Issue #$ARGUMENTS (eller aktuell kontext alternativt fråga efter vilken issue du
vill implementera).

## TDD-arbetsflöde: Red → Green → Refactor

Följ detta strikt för varje funktion/endpoint:

### 1. RED (Skriv failing test)
- Skriv test som beskriver önskat beteende
- Kör testerna - de ska FAIL
- Visa exakt vilket test som failar och varför

### 2. GREEN (Minimal implementation)
- Skriv minimal kod för att få testet att passera
- Ingen fancy lösning - bara tillräckligt för att testet ska bli grönt
- Kör testerna igen - nu ska de PASSA

### 3. REFACTOR (Förbättra)
- Refaktorera koden - förbättra struktur, namn, etc.
- Se till att alla tester fortfarande passerar
- Upprepa RED → GREEN → REFACTOR för nästa del

## Steg:

1. Läs acceptance criteria, edge cases och teknisk kontext från issue.
2. Bryt ner i små uppgifter (en funktion/endpoint i taget).
3. För varje del:
   a. Skriv test PRIMEART (red)
   b. Implementera minimalt (green)
   c. Refaktorera om nödvändigt (refactor)
4. Kör hela testsviten efter varje lyckad Green-fas.
5. Fortsätt tills ALLA tester är gröna.
6. Commit ofta med konventionella meddelanden (feat/fix/refactor):
   !`git commit -m "..."`

Följ @AGENTS.md (clean code, stateless JWT, ingen session, etc.). Visa
diff/change innan skrivning om större fil.
