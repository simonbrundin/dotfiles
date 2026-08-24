---
name: spec-manager
description: |
  Hantera feature-specifikationer i `specs/`. Använd denna skill när användaren
  vill skapa en ny spec eller markera en befintlig spec som slutförd/implementerad.
  
  Utlösare (fras): "skapa en spec", "spec för", "ny spec", "ny feature",
  "markera som done", "slutför spec", "spec är klar", "implementera spec"
---

# Spec Manager

Hanterar feature-specifikationer i `~/repos/agents/specs/`.

## Mappstruktur

```
specs/
├── README.md
├── done/              # Implementerade specs (arkiv)
└── [feature-name].md  # Aktiva specs
```

## Två huvudsakliga operationer

### 1. Skapa ny spec

**Trigger**: användaren säger t.ex. "skapa en spec för notifikationssystem" eller "ny spec för dark mode"

**Workflow**:

1. **Förstå intentionen** — Läs vad användaren har sagt och försök förstå:
   - Vad är feature:en?
   - Varför behövs den?
   - Finns det redan diskuterade detaljer i konversationen?

2. **Fråga om oklarheter** om det behövs, t.ex.:
   - "Vilken prioritet ska den ha? (low/medium/high)"
   - "Vilka tags passar? (ui, backend, api, ux, etc.)"
   - Finns det specifika krav eller acceptanskriterier?

3. **Skapa filen**:
   - Filnamn: `kebab-case.md` baserat på feature-namnet
   - Path: `~/repos/agents/specs/[filnamn].md`
   - Frontmatter med metadata
   - Mall med sektioner för användaren att fylla i

4. **Uppdatera `specs/README.md`** — Lägg till filen i index (eller låt indexet vara automatiskt via <!-- index --> om det finns)

**Mall för ny spec**:

```markdown
---
status: idea
priority: medium
tags: [ui, backend]
created: 2026-01-13
---

# [Feature-namn]

## Bakgrund

Varför behövs denna feature? Vilket problem löser den?

## Beskrivning

Vad ska den göra? Beskriv beteendet.

## Acceptanskriterier

- [ ] Kriterium 1
- [ ] Kriterium 2
- [ ] Kriterium 3

## Anteckningar

Ytterligare tankar, prioriteringar, eller komplexitetsnoteringar.
```

### 2. Slutför spec (markera som done)

**Trigger**: användaren säger t.ex. "slutför notifikationssystem-specen" eller "specen är klar, flytta till done"

**Workflow**:

1. **Hitta spec-filen** — Sök i `specs/` (ej `done/`) efter filnamn som matchar användarens angivelse

2. **Uppdatera frontmatter**:
   ```yaml
   status: done
   completed: 2026-01-13  # dagens datum
   ```

3. **Flytta filen** till `specs/done/`:
   ```
   mv ~/repos/agents/specs/[filnamn].md ~/repos/agents/specs/done/[filnamn].md
   ```

4. **Bekräfta** för användaren att filen är flyttad och var den finns

### Status-ändring (annan än done)

Om användaren säger t.ex. "sätt status till planned" eller "ändra prioritet till high":

1. Hitta filen
2. Uppdatera relevanta fält i frontmatter
3. Bekräfta ändringen

## Filnamn-konvention

Generera automatiskt till `kebab-case.md`:
- "Dark Mode" → `dark-mode.md`
- "User Authentication Flow" → `user-authentication-flow.md`
- "API v2" → `api-v2.md`

## Regler

- Fråga alltid om oklarheter innan du skapar — det är bättre att fråga en extra gång än att gissa fel
- Om användaren nämner en spec och den inte finns, fråga om de vill skapa den
- Behåll alltid `created`-datumet oförändrat vid uppdateringar
- Lägg endast till `completed`-datum när status sätts till `done`
