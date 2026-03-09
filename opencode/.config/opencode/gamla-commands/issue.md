---
description: Skapa en ny GitHub issue med standardmallen
agent: plan
---

# Skapa ny Issue i GitHub

Du är expert på att formulera tydliga GitHub issues.

Använd alltid följande struktur (anpassa efter beskrivning i $ARGUMENTS):

Fråga dig fram till allt du behöver ha svar på.

Titel: Kort & självförklarande – Vad ska uppnås? (The Why + What)

Beskrivning:

## Vad ska uppnås?

Förstå omfattningen. Ställ 1–2 förtydligande frågor om omfattningen känns
otydlig:

”Är det här en ny funktion eller en ändring i befintlig funktionalitet?” ”Vad är
det förväntade resultatet när detta är klart?” ”Finns det några begränsningar
eller krav jag bör känna till?”

## Acceptance criteria

- [ ] Punkt 1
- [ ] Punkt 2 ...

## Edge cases & icke-funktionella krav

- [ ] Punkt 2 ...

- Felhantering: ...
- Prestanda: ...
- Säkerhet: ...
- Kompatibilitet: ...

## Teknisk kontext / begränsningar

- Redan existerande: ...

- Får INTE: ...

## Hur jag tänkt (valfritt)

...

## Relaterat

- #XX
- ADR-XXX
- Figma: ...

## Typ

Definera om det är en feat/fix/refactor etc

Skapa issuen med gh CLI:
!`gh issue create --title "TITEL_HÄR" --body "BODY_HÄR" --label "TYP_HÄR,time-estimate:M" --assignee "@me" 2>&1`

Kopiera exakt kommandot du skulle kör exekvering (fråga om OK om osäker).
exekvering (fråga om OK om
osäker).` Kopiera exakt kommandot du skulle kör exekvering (fråga om OK om osäker). exekvering (fråga om OK om osäker).`
