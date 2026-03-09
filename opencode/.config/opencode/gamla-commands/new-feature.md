---
description: Skapar en ny feature
agent: build
---

Skapar en ny feature-fil baserat på Gherkin. Om inget feature-namn anges som
argument, fråga efter det.

## Instruktioner

1. **Om argument ej anges**: Fråga efter feature-namn (kebab-case, t.ex.
   "user-authentication")
2. **Skapa feature-mall** med:
   - Feature-titel (från argument eller input)
   - Beskrivning (fråga användaren kort)
   - One-liner som background/intro om det är relevant
3. **Scenarier**:
   1. Fråga användaren ifall den har några scenarier den vill lägga till
   2. Föreslå scenarier ifall du tycker det fattas några
4. **Spara fil** som `{feature-namn}.feature` i `{REPO_PATH}/features/`

## Gherkin-mall

```gherkin
Feature: [Titel]

  [Beskrivning]

  Scenario: [Happy path]
    Given [förutsättning]
    When [händelse]
    Then [förväntat resultat]

  Scenario: [Edge case]
    Given [förutsättning]
    When [händelse]
    Then [förväntat resultat]
```

## Exempel

Om användaren anger "user-login" som namn, skapa:

- Feature: User Login
- Beskrivning baserat på input
- Första scenariot som happy path
- Första scenariot som happy path
