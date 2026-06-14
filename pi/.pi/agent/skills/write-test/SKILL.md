---
name: write-test
description: |
  Skapa och skriva tester för din kod. Utlös DENNA SKILL ALLTID när användaren
  säger något om att skriva, skapa, ändra, uppdatera, eller generera tester -
  oavsett ramverk eller typ.
  
  Triggerexempel: "skriv ett test för X", "create test for function", 
  "lägg till tester för komponenten", "write tests", "testa funktionen Y",
  "skapa test suite för API", "gherkin test för login", "BDD test",
  " cucumber feature för checkout", "lägg till unit test", "write integration test",
  "skapa e2e test", "jag behöver test coverage för denna fil",
  "generera tester automatiskt", "mocker ett API i testerna".
  
  OAVSETT om användaren nämner ett specifikt testramverk (Jest, Vitest, Mocha,
  Jasmine, Cucumber, Cypress, Playwright, etc.) - DENNA SKILL ska alltid aktiveras.
  
  Tests placeras i <current-repo>/tests (t.ex. ~/repos/plan/tests,
  ~/repos/deployment-pipeline/tests).
  
  ⚠️ VIKTIGT: Denna skill frågar ALLTID användaren innan någon ändring görs
  med edit. Förklara alltid varför en ändring behövs och vänta på bekräftelse.
---

# Write Test Skill

Denna skill hjälper dig skapa, uppdatera, förbättra och förfina tester för din kod.
Den stödjer BDD/Gherkin med Cucumber.js, enhetstester, integrationstester, och E2E-tester.

> **🎯 Metodik: Red-Green-Refactor (TDD)**
> 
> För BDD/Gherkin-tester ska du ALLTID följa denna cykel:
> 1. **🔴 RED** — Skriv Gherkin + tomma steg-definitioner → Testet ska *misslyckas*
> 2. **🟢 GREEN** — Implementera minimalt → Testet ska *passera*
> 3. **♻️ REFACTOR** — Anslut till verklig kod (API/UI) → Fortfarande *grönt*
> 
> **Gäller även vid underhåll:** Samma cykel när du uppdaterar, förbättrar eller förfinar tester.

---

## 🔧 UNDERHÅLL: Uppdatera, förbättra eller förfina tester

Denna skill ska även användas när du vill **uppdatera, förbättra eller förfina** ett befintligt test, scenario eller feature. Följ samma Red-Green-Refactor-cykel.

### ⚠️ VIKTIGT: Fråga alltid innan du gör ändringar

**Innan du använder `edit` för att lägga till, ta bort eller ändra något i testfilerna måste du:**

1. **Fråga användaren** om de vill att du ska göra ändringen
2. **Förklara varför** du tycker ändringen behövs
3. **Vänta på bekräftelse** innan du använder edit

### När ska du använda denna skill?

| Typ | Exempel | Trigger-fraser |
|-----|---------|----------------|
| **Uppdatera** | Lägga till edge case, nytt scenario | "lägg till test för X", "utöka scenariot", "nytt felscenario" |
| **Förbättra** | Göra steg-definitioner renare, lägga till Page Objects | "förbättra testerna", "refaktorera stegen", "gör testerna mer robusta" |
| **Förfina** | Fokusera om ett scenario, dela upp | "förfina scenariot", "dela upp i fler scenarier", "fokusera på happy path" |
| **Fixa** | Rätta ett trasigt test | "testet fungerar inte", "fiksar testet för X", "testet misslyckas" |

### 🚨 Att lägga till nya scenarier

När du identifierar att ett nytt scenario behövs:

1. **Föreslå scenariot** muntligt/текстуellt
2. **Förklara varför** det behövs (se mall nedan)
3. **Fråga**: "Vill du att jag lägger till detta scenario?"
4. **Vänta på svar** innan du gör edit

**Mall för att föreslå scenario:**

```
📝 Föreslaget scenario:

Scenario: [Namn]
  Given [förutsättning]
  When [handling]
  Then [resultat]

💡 Varför jag föreslår detta:
- [Anledning 1]
- [Anledning 2]
- [Konsekvens om det inte testas]

❓ Vill du att jag lägger till detta scenario? (ja/nej/ändra)
```

### 🚨 Att uppdatera/förbättra befintliga scenarier

**⚠️ VIKTIGT: Gör en ändring i taget!**

När du analyserar befintliga tester och hittar förbättringsmöjligheter:


1. **Visa ETT scenario i taget** — Aldrig alla på en gång
2. **Fråga om samtycke** för varje ändring
3. **Vänta på svar** innan du gör nästa

**❌ DÅLIGT exempel (alla på en gång):**

```
Jag har hittat 5 scenarier som kan förbättras. Vill du att jag gör alla?

| Scenario | Ändring |
|---------|---------|
| 1 | Lägg till felscenario |
| 2 | Lägg till Scenario Outline |
| 3 | Lägg till Background |
...
```

**✅ BRA exempel (ett i taget):**

```
Jag ser ett scenario som saknar felscenario-hantering.

❓ Föreslår scenario:

Scenario: Inloggning misslyckas med fel lösenord
  Given Emma har ett konto med epost "emma@test.se" och lösenord "Säkert123"
  When Emma försöker logga in med fel lösenord
  Then Emma ska få ett tydligt felmeddelande

💡 Varför: Utan detta scenario vet vi inte vad som händer vid fel lösenord.

Vill du att jag lägger till detta scenario? (ja/nej/ändra)
```

**Efter bekräftelse, fortsätt med nästa:**


```
✅ Scenario tillagt!


Nästa förbättring jag ser är...

❓ Föreslår scenario:

Scenario: Image byggs med olika taggar
  Given enhetstesterna passerar
  When CI-flödet bygger Docker-image med taggen "<tag>"
  Then ska en image skapas med taggen "<tag>"

  Examples: Taggar
  | tag    |
  | latest |
  | v1.0.0 |

💡 Varför: Scenario Outline låter oss testa flera konfigurationer.

Vill du att jag lägger till detta scenario? (ja/nej/ändra)
```

**Regler för uppdatering:**

| Gör | Undvik |
|-----|--------|
| Fråga om ETT scenario i taget | Visa alla scenarier i en tabell |
| Vänta på svar innan nästa | Gör alla ändringar samtidigt |
| Förklara varför varje ändring behövs | Dumpa en lista utan förklaring |
| Bekräfta efter varje lyckad ändring | Fortsätta utan bekräftelse |

### Arbetsflöde för underhåll

#### 1️⃣ Läs befintligt test
Läs det befintliga testet och förstå vad det gör:

```gherkin
# Befintligt scenario
Scenario: Lyckad inloggning
  Given Emma har ett konto med epost "emma@test.se" och lösenord "Säkert123"
  When Emma loggar in på sajten
  Then Emma ska se sin dashboard
```

#### 2️⃣ 🔴 RED — Föreslå det nya/uppdaterade testet

**VIKTIGT: Fråga alltid användaren innan du lägger till något!**

Identifiera det scenario som behövs och föreslå det för användaren med en förklaring:

```
🔴 RED — Jag har identifierat ett scenario som bör läggas till:

Scenario: Inloggning med fel lösenord
  Given Emma har ett konto med epost "emma@test.se" och lösenord "Säkert123"
  When Emma försöker logga in med fel lösenord
  Then Emma ska få ett tydligt felmeddelande
  And Emma ska fortfarande vara på inloggningssidan

💡 Varför detta scenario behövs:
1. **Täckning**: Om användaren skriver fel lösenord måste systemet hantera det
2. **Användarupplevelse**: Användaren behöver veta att lösenordet var fel
3. **Säkerhet**: Vi verifierar att inte hela inloggningsflödet låser sig

❓ Vill du att jag lägger till detta scenario? (ja/nej/ändra)
```

**Vänta på användarens svar innan du fortsätter.**

När användaren bekräftar, lägg till scenariot eller ändra det befintliga:

```gherkin
# Nytt scenario som ska läggas till
Scenario: Inloggning med fel lösenord
  Given Emma har ett konto med epost "emma@test.se" och lösenord "Säkert123"
  When Emma försöker logga in med fel lösenord
  Then Emma ska få ett tydligt felmeddelande
  And Emma ska fortfarande vara på inloggningssidan
```

**Skriv steg-definitionerna som tomma/icke-implementerade** → Ska misslyckas

#### 3️⃣ 🟢 GREEN — Fråga om implementation

Efter att scenariot är lagt till:

1. **Föreslå implementationen** av steg-definitionerna
2. **Fråga**: "Vill du att jag implementerar steg-definitionerna?"
3. **Vid refactor**: Fokusera på att uppdatera steg-definitioner (se nedan)

Lägg till steg-definitionerna med minimal kod:

```javascript
When('Emma försöker logga in med fel lösenord', function () {
  // 🟢 GREEN: Minimal implementation
  this.loginResult = { success: false, error: 'Felaktigt lösenord' };
});

Then('Emma ska få ett tydligt felmeddelande', function () {
  if (!this.loginResult.error) {
    throw new Error('Inget felmeddelande');
  }
});
```

**❓ Vill du att jag implementerar steg-definitionerna?**

Vid REFACTOR:
- **Steg-definitioner är fokus**: När du refaktorera ett test handlar det oftast om att uppdatera, dela upp eller förbättra befintliga steg-definitioner
- **Skapa nya steg**: När befintliga steg inte passar, skapa nya generiska steg
- **Dela upp i Page Objects**: Extrahera UI-interaktioner till återanvändbara Page Object-klasser

```javascript
When('Emma försöker logga in med fel lösenord', function () {
  // 🟢 GREEN: Minimal implementation
  this.loginResult = { success: false, error: 'Felaktigt lösenord' };
});

Then('Emma ska få ett tydligt felmeddelande', function () {
  if (!this.loginResult.error) {
    throw new Error('Inget felmeddelande');
  }
});
```

#### 4️⃣ ♻️ REFACTOR — Uppdatera steg-definitioner

**Refaktorering av tester handlar mest om att uppdatera steg-definitioner:**

1. **Byt ut mock mot verklig kod** i steg-definitionerna
2. **Anslut till verkliga API:er** (fetch/axios)
3. **Anslut till UI-selektorer** (Playwright/Cypress)
4. **Skapa Page Objects** för UI-interaktioner
5. **Extrahera gemensam logik** till helpers
6. **Förbättra felmeddelanden** för bättre felsökning

**⚠️ Fråga alltid innan du ändrar steg-definitioner:**

```
♻️ REFACTOR — Jag föreslår följande uppdatering av steg-definitioner:

1. **Dela upp i Page Objects**:
   - Skapa `LoginPage` med metoder: `fillEmail()`, `fillPassword()`, `clickLogin()`
   
2. **Byt ut mock mot fetch**:
   - Ersätt `this.loginResult = {...}` med:
   ```javascript
   const response = await fetch('/api/login', {
     method: 'POST',
     body: JSON.stringify({ email, password })
   });
   ```

3. **Lägg till felmeddelanden**:
   - Förbättra assertioner med kontext

💡 Varför detta behövs:
- [Anledning]

❓ Vill du att jag gör dessa ändringar? (ja/nej/ändra)
```

```javascript
When('Emma försöker logga in med fel lösenord', async function () {
  // ♻️ REFACTOR: Riktigt API-anrop
  const response = await fetch('/api/login', {
    method: 'POST',
    body: JSON.stringify({
      email: 'emma@test.se',
      password: 'fel_lösenord'
    })
  });
  this.response = response;
  this.responseBody = await response.json();
});

Then('Emma ska få ett tydligt felmeddelande', function () {
  if (this.response.status === 200) {
    throw new Error('Inloggningen lyckades — borde ha misslyckats');
  }
  if (!this.responseBody.error) {
    throw new Error('Inget felmeddelande i svaret');
  }
});
```

#### 5️⃣ Verifiera alla tester
Kör hela test-sviten för att säkerställa att ändringarna inte bröt något annat:

```bash
bun test
# ✓ Alla scenarier passerar
```

#### 6️⃣ Fortsätt med nästa scenario

**Efter varje lyckad ändring, fråga om nästa:**

```
✅ Scenario tillagt och testerna passerar!


Jag har fler förbättringsidéer. Vill du att jag fortsätter? (ja/nej)
```

**Om ja, visa nästa scenario ETT i taget:**
```
Nästa förbättring jag ser är att lägga till en Scenario Outline...

❓ Föreslår scenario:

Scenario Outline: Tester körs med olika miljövariabler
  Given en testmapp finns
  And miljövariabler är satta:
    | variabel | värde    |
    | NODE_ENV | <env>    |
  When CI-flödet kör enhetstester
  Then ska alla tester passera

  Examples: Konfigurationer
  | env    |
  | test   |
  | staging|

💡 Varför: Scenario Outline låter oss testa flera konfigurationer effektivt.

Vill du att jag lägger till detta scenario? (ja/nej/ändra)
```

---

### 💡 Tips vid underhåll

1. **Gör en ändring i taget** — Lägg till EN edge case, inte fem på en gång
2. **Kör testerna efter varje cykel** — Verifiera att allt fortfarande grönt
3. **Förbättra inte i RED-fasen** — Fokusera på att få testet grönt först
4. **Dokumentera ändringar** — Lägg till kommentarer om varför scenariot ändrades
5. **Fråga alltid innan edit** — Använd aldrig edit utan att först fråga och förklara
6. **Visa aldrig alla ändringar samtidigt** — Fråga om ETT scenario i taget

### ⚠️ Vanliga misstag vid underhåll

| Misstag | Istället |
|--------|----------|
| Lägga till 10 nya scenarier på en gång | Lägg till ETT scenario, kör test, refaktorera |
| Visa alla förbättringar i en tabell | Visa ETT scenario i taget med förklaring |
| Börja med REFACTOR direkt | Gå alltid RED → GREEN → REFACTOR |
| Glömma att köra hela test-sviten | Kör alltid `bun test` efter ändringar |
| Ändra befintliga scenarier för mycket | Lägg till NYA scenarier istället |
| Göra edit utan att fråga först | Fråga alltid "Vill du att jag gör X?" |

---

## 🗣️ INTERAKTIVTARBETSFLÖDE: Steg-för-steg med Given-When-Then

**Detta är det primära arbetsflödet för denna skill.** Följ det alltid när användaren vill skapa tester.

### 🔴🟢♻️ Red-Green-Refactor (TDD-cykeln för BDD)

För Gherkin/Cucumber-tester ska du ALLTID följa denna cykel:

#### **STEG 1: 🔴 RED — Skriv Gherkin-testet (som förväntas misslyckas)**

1. **Skriv feature-filen** med Gherkin-scenariot
2. **Skriv steg-definitionerna som SKA finnas** — men de ska bara kasta `Pending` eller `undefined`
3. **Kör testerna** — de ska **misslyckas** med "UndefinedStepException" eller "Pending"

```gherkin
# tests/features/konto.feature
Feature: Skapa konto

  Som ny användare
  Vill jag kunna skapa ett konto
  För att kunna logga in

  @smoke
  Scenario: Registrera ny användare
    Given Anna är på registreringssidan
    When Anna fyller i giltig epost "anna@test.se" och lösenord "Säkert123"
    And Anna klickar på "Skapa konto"
    Then Anna ska vara inloggad
    And Anna ska få ett bekräftelsemejl
```

```javascript
// tests/features/step_definitions/konto.js
const { Given, When, Then, Before } = require('@cucumber/cucumber');

// 🔴 RED: Stegen är definierade men gör inget — de ska misslyckas
// Kör: bun test
// Förväntat resultat: "Undefined step: Anna är på registreringssidan" etc.

Given('Anna är på registreringssidan', function () {
  // 🔴 INTE IMPLEMENTERAD ÄN - detta är avsiktligt!
  throw new cucumber.TransformCaseDefinition('Anna är på registreringssidan');
});

When('Anna fyller i giltig epost {string} och lösenord {string}', function (epost, lösenord) {
  throw new cucumber.TransformCaseDefinition('Anna fyller i...');
});

When('Anna klickar på {string}', function (knapp) {
  throw new cucumber.TransformCaseDefinition('Anna klickar på...');
});

Then('Anna ska vara inloggad', function () {
  throw new cucumber.TransformCaseDefinition('Anna ska vara inloggad');
});

Then('Anna ska få ett bekräftelsemejl', function () {
  throw new cucumber.TransformCaseDefinition('Anna ska få...');
});
```

**Verifiera:** Kör `bun test` → Testerna ska **misslyckas** (RED).

---

#### **STEG 2: 🟢 GREEN — Skriv minimal kod för att göra testerna gröna**

Nu implementerar du steg-definitionerna med **minimal funktionalitet** bara för att testerna ska passera.

```javascript
// tests/features/step_definitions/konto.js
const { Given, When, Then } = require('@cucumber/cucumber');

// 🟢 GREEN: Minimal implementation — räcker för att testet ska passera

// Mock-state för testet
let state = {
  currentPage: null,
  user: null,
  emailSent: false
};

Given('Anna är på registreringssidan', function () {
  // 🟢 GREEN: Sätt state till rätt sida
  state.currentPage = 'registration';
  // Inget mer — vi behöver bara komma vidare
});

When('Anna fyller i giltig epost {string} och lösenord {string}', function (epost, lösenord) {
  // 🟢 GREEN: Spara user data
  state.user = { email: epost, password: lösenord };
});

When('Anna klickar på {string}', function (knapp) {
  // 🟢 GREEN: Simulera klick
  if (knapp === 'Skapa konto') {
    state.user.created = true;
    state.emailSent = true;
    state.currentPage = 'dashboard';
  }
});

Then('Anna ska vara inloggad', function () {
  // 🟢 GREEN: Verifiera minimalt
  if (!state.user || !state.user.created) {
    throw new Error('Användaren är inte inloggad');
  }
});

Then('Anna ska få ett bekräftelsemejl', function () {
  // 🟢 GREEN: Verifiera email skickades
  if (!state.emailSent) {
    throw new Error('Bekräftelsemejl skickades inte');
  }
});
```

**Verifiera:** Kör `bun test` → Alla tester ska **passera** (GREEN).

---

#### **STEG 3: ♻️ REFACTOR — Anslut till verklig kod**

Nu när testerna passerar är det dags att byta ut mock-state mot **riktiga API-anrop och UI-interaktioner**:

**🎯 Mål: Testa din verkliga applikationskod, inte test-mocks**

1. **Anslut till riktiga API:er** — Byt ut mock-state mot `fetch()` eller liknande
2. **Anslut till UI/selektorer** — Använd Playwright/Cypress för att interagera med riktiga element
3. **Dela upp i Page Objects** — Om det är UI-tester, skapa en `LoginPage`-klass
4. **Extrahera gemensam logik** till helpers (t.ex. `waitForElement`, `sendRequest`)
5. **Förbättra felmeddelanden** — Ge kontext när något går fel
6. **Skriv om steg för återanvändning** — Generiska steg som fungerar överallt

```javascript
// ♻️ REFACTOR: Anslut till verklig kod

// tests/features/support/world.js
class TestWorld {
  constructor() {
    this.reset();
  }

  reset() {
    this.baseUrl = process.env.API_URL || 'http://localhost:3000';
    this.user = null;
    this.response = null;
    this.errors = [];
  }


  async sendRequest(method, endpoint, body = {}) {
    this.response = await fetch(this.baseUrl + endpoint, {
      method,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body)
    });
    return this.response;
  }
}

// tests/features/step_definitions/konto.js
const { Given, When, Then, Before } = require('@cucumber/cucumber');

Before(function () {
  this.state = new TestWorld();
});

Given('Anna är på registreringssidan', async function () {
  // ♻️ REFACTOR: Riktig navigation med Playwright/Cypress
  await this.driver.goto('/register');
});

When('Anna fyller i giltig epost {string} och lösenord {string}', async function (email, password) {
  // ♻️ REFACTOR: Riktiga UI-interaktioner
  await this.driver.fill('[data-testid="email"]', email);
  await this.driver.fill('[data-testid="password"]', password);
});

When('Anna klickar på {string}', async function (button) {
  // ♻️ REFACTOR: Riktig knapptryckning
  await this.driver.click(`[data-testid="${button.toLowerCase()}"]`);
});

Then('Anna ska vara inloggad', async function () {
  // ♻️ REFACTOR: Verifiera mot verklig URL/cookie
  const url = this.driver.getCurrentUrl();
  if (!url.includes('/dashboard')) {
    throw new Error(`Förväntade /dashboard, fick ${url}`);
  }
});

Then('Anna ska få ett bekräftelsemejl', async function () {
  // ♻️ REFACTOR: Verifiera via API att email skickades
  // (mockar MailHog/Mailtrap för testning)
  const emails = await this.mailClient.getEmails(this.state.user.email);
  if (emails.length === 0) {
    throw new Error('Inget bekräftelsemejl mottaget');
  }
});
```

**💡 API-test exempel:**

```javascript
// ♻️ REFACTOR: För ren API-testning

When('Anna fyller i giltig epost {string} och lösenord {string}', function (email, password) {
  this.requestBody = { email, password };
});

When('Anna klickar på {string}', async function (button) {
  if (button === 'Skapa konto') {
    // ♻️ REFACTOR: Riktigt API-anrop
    this.response = await this.state.sendRequest('POST', '/api/users', this.requestBody);
    this.responseBody = await this.response.json();
  }
});

Then('Anna ska vara inloggad', async function () {
  // ♻️ REFACTOR: Verifiera från riktigt svar
  if (this.response.status !== 201) {
    throw new Error(`Förväntade 201, fick ${this.response.status}`);
  }
  if (!this.responseBody.token) {
    throw new Error('Ingen JWT-token i svaret');
  }
});
```

**⚠️ Viktigt:** I REFACTOR-fasen ska du:
- **Byta ut mock-state** mot riktiga anrop
- **Verifiera mot verklig applikation** (databas, API, UI)
- **Använda miljövariabler** för att konfigurera test-url:er
- **Kör testerna igen** — de ska fortfarande passera med verklig kod!

---

### 🔄 Komplett exempel: Från tom fil till refaktorerad kod

```
╔══════════════════════════════════════════════════════════════════════╗
║                    Red-Green-Refactor för BDD                          ║
╠══════════════════════════════════════════════════════════════════════╣
║  1. 🔴 RED     → Skriv Gherkin + tomma steg-definitioner             ║
║  2. 🟢 GREEN   → Kör test, se det misslyckas, implementera minimalt  ║
║  3. ♻️ REFACTOR → Test passerar, förbättra struktur & återanvändning  ║
║  4. 🔄 UPREPRA → Nästa scenario börjar vid STEG 1                    ║
╚══════════════════════════════════════════════════════════════════════╝
```

**Arbetsflöde med cykeln:**

1. **Fråga användaren om scenariot** (Given-When-Then)
2. **Skriv Gherkin → Köra test → 🔴 RED**
3. **Skriv minimala steg-definitioner → Köra test → 🟢 GREEN**
4. **Refaktorera om det behövs → Köra test → ✅ Fortfarande grönt**
5. **Fortsätt med nästa scenario**

---

### 💡 Red-Green-Refactor Quick Guide

| Fas | Fråga att ställa | Output |
|-----|-----------------|--------|
| 🔴 RED | "Vad ska testet verifiera?" | Gherkin + steg-definitioner (ej implementerade) |
| 🟢 GREEN | "Vad är MINIMALT som behövs?" | Steg-definitioner som passerar (mock/state) |
| ♻️ REFACTOR | "Hur ansluter jag till verklig kod?" | Riktiga API:er, UI-interaktioner, Page Objects |

### ⚠️ Viktiga regler för Red-Green-Refactor

1. **Gå aldrig vidare till GREEN innan RED är verifierad** — testet måste ha misslyckats först
2. **GREEN ska vara minimal** — skriv bara nog för att passera, inget mer
3. **♻️ REFACTOR = Byt ut mock mot verklig kod** — Anslut till riktiga API:er och UI
4. **Refaktorera aldrig om det bryter testerna** — alla tester ska fortfarande passera
5. **Upprepa för varje scenario** — behandla varje scenario som en egen TDD-cykel

### Interaktiv Gherkin-design (inom Red-Green-Refactor)

**⚠️ VIKTIGT: Designa alltid scenariot INTERAKTIVT med användaren innan du skriver något!**

Efter att ha etablerat cykeln, designa Gherkin-scenariot tillsammans med användaren. **Skriv ALDRIG till filen innan användaren har bekräftat scenariot.**

#### Steg 1: Namnge scenariot

**Fråga användaren:**
> "Vad ska scenariot heta? Ge gärna ett beskrivande namn som beskriver vad som testas."

Ge 2-3 förslag baserat på kontexten, t.ex.:
- "Lyckad inloggning"
- "Användare loggar in med giltiga uppgifter"
- "Inloggning med korrekt epost och lösenord"

**Användaren kan:**
- Välja ett förslag
- Skriva något helt eget
- Föreslå ändringar till ett förslag

---

#### Steg 2: Definiera Given (förutsättningar)

**Fråga användaren:**
> "Vilka förutsättningar gäller innan användaren agerar? Vad måste vara sant först?"

**Ge 3 förslag på Given-steg** (från enklast till mest detaljerat):

```
Förslag A (minimalt):
  Given en registrerad användare

Förslag B (medium):
  Given Emma har ett konto med epost "emma@test.se"

Förslag C (detaljerat):
  Given Emma har ett konto med epost "emma@test.se" och lösenord "Säkert123"
```

**Användaren kan:**
- Välja ett förslag (A, B eller C)
- Kombinera element från flera förslag
- Skriva något helt eget
- Lägga till fler Given-steg med "And"

**Upprepa tills användaren är nöjd:**
> "Är du nöjd med Given-delen? Vill du lägga till fler förutsättningar?"

---

#### Steg 3: Definiera When (handling)

**Fråga användaren:**
> "Vad gör användaren? Vilken handling triggar testet?"

**Ge 3 förslag på When-steg**:

```
Förslag A (minimalt):
  When Emma loggar in

Förslag B (medium):
  When Emma loggar in med rätt uppgifter

Förslag C (detaljerat):
  When Emma anger epost "emma@test.se" och lösenord "Säkert123"
```

**Användaren kan:**
- Välja ett förslag
- Kombinera element
- Skriva något helt eget
- Lägga till fler When-steg med "And"

**Upprepa tills användaren är nöjd:**
> "Är du nöjd med When-delen?"

---

#### Steg 4: Definiera Then (resultat)

**Fråga användaren:**
> "Vad förväntas hända? Vad ska användaren se/få/uppleva?"

**Ge 3 förslag på Then-steg**:

```
Förslag A (enkelt):
  Then Emma ska se sin dashboard

Förslag B (medium):
  Then Emma ska se sin dashboard
  And Emma ska få ett välkomstmeddelande

Förslag C (detaljerat):
  Then Emma ska vara inloggad
  And Emma ska se sin personliga dashboard
  And URL:en ska vara "/dashboard"
```

**Användaren kan:**
- Välja ett förslag
- Kombinera element
- Skriva något helt eget
- Lägga till fler Then-steg med "And"

**Upprepa tills användaren är nöjd:**
> "Är du nöjd med Then-delen? Vill du lägga till fler förväntade resultat?"

---

#### Steg 5: Sammanfattning och bekräftelse

**Visa hela scenariot:**
```gherkin
Scenario: [Scenarionamn]
  Given [förutsättning]
  When [handling]
  Then [förväntat resultat]
```

**Fråga användaren:**
> "Så här ser scenariot ut. Är det korrekt? Vill du ändra något?"

**Alternativ:**
- "Ja, det är perfekt!" → Fortsätt med RED-steget i Red-Green-Refactor
- "Jag vill ändra [Given/When/Then]" → Gå tillbaka till det steget
- "Lägg till ett till scenario" → Börja om från Steg 1

**⚠️ SKRIV INTE TILL FIL förrän användaren bekräftar!**

Efter bekräftelse, fråga:
> "Nu kan jag lägga till scenariot i feature-filen. Vill du att jag gör det? (ja/nej)"

---

### 💡 Exempel: Komplett konversation med Red-Green-Refactor

```
AI: Vad ska scenariot heta?
ANVÄNDARE: Inloggning

AI: Okej! Här är några förslag:
  A) Användare loggar in
  B) Emma loggar in på sajten
  C) Registrerad användare loggar in med giltiga uppgifter
  Vad passar bäst, eller vill du skriva något eget?

ANVÄNDARE: B

AI: Vilka förutsättningar gäller?
  A) Given en registrerad användare
  B) Given Emma har ett konto
  C) Given Emma har ett konto med epost "emma@test.se" och lösenord "Säkert123"

ANVÄNDARE: C

AI: Vad gör Emma sen?
  A) When Emma loggar in
  B) When Emma loggar in på sajten
  C) When Emma klickar på "Logga in"

ANVÄNDARE: B

AI: Vad förväntas hända?
  A) Then Emma ska vara inloggad
  B) Then Emma ska se sin dashboard
  C) Then Emma ska se sin dashboard och få ett välkomstmeddelande

ANVÄNDARE: C

AI: Här är ditt scenario:

  Scenario: Emma loggar in på sajten
    Given Emma har ett konto med epost "emma@test.se" och lösenord "Säkert123"
    When Emma loggar in på sajten
    Then Emma ska se sin dashboard och få ett välkomstmeddelande

  Är det korrekt?

ANVÄNDARE: Ja!

AI: ✅ Perfekt! Nu kan jag lägga till scenariot i feature-filen.
  
  ❓ Vill du att jag gör det? (ja/nej)

ANVÄNDARE: Ja!

AI: Perfekt!

  🔴 RED: Jag skapar feature-filen och tomma steg-definitioner...
  [Skapar filerna]
  
  Kör testerna för att verifiera att de misslyckas:
  $ bun test
  
  Resultat: ✗ Scenarios: 1 failed, 0 passed
  
  🔴 Verifierat — testerna misslyckas som förväntat!

ANVÄNDARE: Bra!

AI: 🟢 GREEN: Nu implementerar jag steg-definitionerna...
  
  ❓ Vill du att jag implementerar steg-definitionerna med minimal kod? (ja/nej)

ANVÄNDARE: Ja!

AI: [Implementerar minimal kod]
  
  Kör testerna igen:
  $ bun test
  
  Resultat: ✓ Scenarios: 1 passed, 0 failed
  
  🟢 Klart — testerna passerar!

ANVÄNDARE: Perfekt!

AI: ♻️ REFACTOR: Vill du att jag refaktorerar koden? 
  Jag kan:
  A) Skapa en World-klass för delad kontext
  B) Extrahera till Page Objects
  C) Lägga till bättre felmeddelanden
  D) Kör utan refactor (testet är redan grönt)

ANVÄNDARE: A

AI: ♻️ REFACTOR — Jag föreslår följande:

1. Skapa `TestWorld`-klass med:
   - `baseUrl`, `response`, `responseBody`
   - `sendRequest(method, endpoint, body)`

2. Uppdatera steg-definitioner till:
   ```javascript
   Before(function () {
     this.state = new TestWorld();
   });
   ```

💡 Varför detta behövs:
- Återanvändbar konfiguration
- Delad kontext mellan steg
- Enklare att ansluta till riktiga API:er senare

  ❓ Vill du att jag gör dessa ändringar? (ja/nej/ändra)

ANVÄNDARE: Ja!

AI: ♻️ Refaktorerar...
  [Uppdaterar steg-definitioner]
  
  Verifierar att testerna fortfarande passerar:
  $ bun test
  
  Resultat: ✓ Scenarios: 1 passed, 0 failed
  
  ✅ Refactor klart — testerna passerar fortfarande!
```

---

## 📋 ADDITIONELL DISCOVERY: Kontextfrågor

**Ställ dessa frågor för att förstå testbehovet bättre:**

### 1. Vem är användaren?
- Vem ska använda denna funktion?
- Är det en kund, admin, intern användare?

### 2. Vad vill användaren uppnå?
- Beskriv i vanligt språk vad användaren vill göra
- Vad är målet med denna funktion?

### 3. Varför bryr sig användaren?
- Vilket problem löser detta?
- Vad händer om det inte fungerar?

### 4. Vilka är de viktigaste resultaten?
- Vad måste hända för att användaren ska vara nöjd?
- Finns det happy path + edge cases?

### 5. Finns det felscenarion?
- Vad kan gå fel?
- Vad ska användaren se/få när något går fel?

### 6. Tekniska frågor (bara om nödvändigt)
- Vilket testramverk använder projektet?
- Finns det befintliga tester att bygga vidare på?

---

## ✨ DEKLARATIV INSTEÄLL FÖR IMPERATIV

**🎯 MÅL: Skriv scenarier som fokuserar på VAD användaren uppnår, inte HUR de gör det.**

### ❌ Dåligt exempel (imperativt - för detaljerat)

```gherkin
Scenario: Användare loggar in
  Given jag är på sidan "/login"
  When jag skriver "test@example.com" i fältet "email"
  And jag skriver "lösenord123" i fältet "password"
  And jag klickar på knappen "Logga in"
  Then jag ska se "Välkommen" på sidan
  And URL:en ska vara "/dashboard"
```

### ✅ Bra exempel (deklarativt - användarfokuserat)

```gherkin
Scenario: Användare loggar in
  Given Emma har ett konto med epost "emma@test.se"
  When Emma loggar in med rätt uppgifter
  Then Emma ska se sin personliga dashboard
  And Emma ska få ett välkomstmeddelande
```

### 💡 Varför deklarativt är bättre

| Aspekt | Deklarativt ✓ | Imperativt ✗ |
|--------|--------------|-------------|
| **Läsbarhet** | Läsbar som vanlig text | Läsbar men detaljerad |
| **Underhåll** | Överlever UI-ändringar | Går sönder vid varje ändring |
| **Fokus** | Affärsvärde | Tekniska steg |
| **Dokumentation** | Lever som specifikation | Blir snabbt föråldrad |

---

## 📝 SKRIV ENKLA SCENARIER

### Regler för enklare scenarier

1. **Max 3-5 steg per scenario** - Färre steg = tydligare fokus
2. **Ett scenario = ett beteende** - testa en sak i taget
3. **Använd riktiga namn** - "Emma" istället för "användaren"
4. **Undvik tekniska termer** - Ingen "API", "POST request", "JWT token"
5. **Beskriv outcome, inte process** - "ska se dashboard" inte "ska redirigeras"

### Mall för enkla scenarier

```gherkin
Feature: [Kort, beskrivande namn]

  Som [roll]
  Vill jag [vad användaren vill]
  För att [varför det är viktigt]

  @smoke
  Scenario: [Happy path - det normala, förväntade flödet]
    Given [förutsättning]
    When [vad användaren gör]
    Then [vad som händer för användaren]

  Scenario: [Edge case - gränsfall]
    Given [annan förutsättning]
    When [vad användaren gör]
    Then [annat resultat]
```

### Exempel: Från komplext till enkelt

**❌ Komplext (10+ steg):**
```gherkin
Scenario: Användare lägger till produkt i varukorgen
  Given användaren är på produktsidan
  When användaren klickar på "Lägg till"
  And varukorgen uppdateras
  And användaren navigerar till /cart
  And sidan laddas
  Then varukorgen visar produkten
  And priset är korrekt
  And antalet är 1
  And totalpriset är summan
```

**✅ Enkelt (3 steg):**
```gherkin
Scenario: Kund lägger till produkt i varukorgen
  Given Anna är på en produktsida
  When Anna klickar på "Lägg till i varukorgen"
  Then varukorgen ska visa produkten med rätt pris
```

---

## 🎨 EXEMPEL: Samma funktion, olika fokus

### Inloggning - BDD stil

```gherkin
Feature: Säker inloggning

  Som registrerad kund
  Vill jag logga in på mitt konto
  För att komma åt mina personliga sidor

  @smoke
  Scenario: Lyckad inloggning
    Given Emma har ett konto med epost "emma@test.se" och lösenord "Säkert123"
    When Emma loggar in på sajten
    Then Emma ska se sin personliga dashboard

  Scenario: Felaktigt lösenord
    Given Emma har ett konto
    When Emma försöker logga in med fel lösenord
    Then Emma ska få ett tydligt felmeddelande
    And Emma ska fortfarande vara på inloggningssidan

  Scenario: Omregistrering
    Given Emma försöker logga in med ett konto som inte finns
    When Emma klickar på "Glömt lösenord"
    Then Emma ska få möjlighet att återställa sitt lösenord
```

---

## Mappstruktur

Alla BDD-tester placeras i `<current-repo>/tests` (där du arbetar):

```
<current-repo>/
├── tests/                     # BDD-tester i aktuellt repo
│   ├── features/               # Gherkin feature-filer
│   │   ├── *.feature          # En feature-fil per domän/område
│   │   └── step_definitions/  # Steg-implementationer
│   │       └── *.js
│   │   └── support/           # Hooks, world, setup
│   │       ├── hooks.js
│   │       └── world.js
│   ├── cucumber.js            # Cucumber konfigurationsfil
│   └── package.json           # Dependencies (hanteras med bun)
└── src/                       # Din applikationskod
```

## Skapa en Feature-fil

### Grundstruktur

```gherkin
Feature: [Beskrivande namn på funktionaliteten]

  Som en [roll]
  Vill jag kunna [funktion]
  För att [affärsnytta/värde]

  Background:                # Valfri: gemensamma steg för alla scenarier
    Given en etablerad konfiguration

  Scenario: [Beskrivande namn]
    Given [förutsättning]
    And   [ytterligare förutsättning]    # "And" upprepar föregående nyckelord
    When  [handling/händelse]
    And   [ytterligare handling]
    Then  [förväntat resultat]
    And   [ytterligare förväntat resultat]

  Scenario Outline: [Mall med exempel]
    Given jag har <antal> objekt
    When jag lägger till <mer>
    Then bör jag ha <totalt> totalt

    Examples: Rubrik
    | antal | mer | totalt |
    | 5     | 3   | 8      |
    | 10    | 2   | 12     |
```

### Nyckelord och deras betydelse

| Nyckelord | Användning |
|-----------|------------|
| `Given`   | Förutsättningar - det initiala tillståndet |
| `When`    | Handlingar - vad användaren gör |
| `Then`    | Resultat - förväntade outcomes |
| `And`     | Lägger till fler steg av samma typ |
| `But`     | Lägger till kontrasterande steg |
| `Background` | Steg som kör före varje scenario |
| `Scenario Outline` | Parameteriserade scenarier med Examples |

### Gherkin-syntaxregler

1. **Indentering**: Använd 2 mellanslag för att indentera steg under nyckelord
2. **Citattecken**: Använd `{string}`, `{int}`, `{float}`, `{word}` för datatyper
3. **Flerradig text**: Använd `"""` för strängar med flera rader
4. **Taggar**: Använd `@tagg` för att organisera scenarier
5. **Kommentarer**: `# Detta är en kommentar` (undvik i produktion)

#### Regler för `@commit`-taggen

**Lägg till `@commit` taggen om scenariot uppfyller ALLA dessa kriterier:**

| Kriterie | Beskrivning |
|----------|-------------|
| ✅ **Billig körning** | Snabb att köra (<1s), låg resursförbrukning |
| ✅ **Inga externa dependencies** | Inget API, ingen databas, ingen nätverksåtkomst |
| ✅ **Självständig** | Kan köras var som helst utan setup |

**Exempel på scenarier som SKA ha `@commit`:**

```gherkin
@commit
Scenario: Rabatt beräknas korrekt
  Given en kundvagn med produkter:
    | produkt  | pris |
    | Skjorta  | 500  |
    | Byxor    | 800  |
  And en rabattkod "SOMMAR20" appliceras
  When totalpriset beräknas
  Then totalpriset ska vara 1040 kr
```

**Exempel på scenarier som INTE ska ha `@commit`:**

```gherkin
# ❌ INTE @commit - kräver API
Scenario: Användare loggar in
  Given en registrerad användare
  When användaren skickar inloggningsförfrågan
  Then ska användaren få en JWT-token
```

```gherkin
# ❌ INTE @commit - kräver databas
Scenario: Användare sparas i databasen
  Given en ny användare med epost "ny@test.se"
  When användaren skapas
  Then ska användaren finnas i databasen
```

**💡 Tips:** `@commit` scenarier är idealiska för att köras vid varje commit, som pre-commit hooks, eller i snabba feedback-loopar.

### Exempel: API-testning

```gherkin
Feature: Användarhantering

  @api @auth
  Scenario: Användare loggar in framgångsrikt
    Given en registrerad användare med epost "test@example.com" och lösenord "Säkert123"
    When jag skickar en POST-förfrågan till "/api/auth/login" med:
      | field    | value            |
      | email    | test@example.com |
      | password | Säkert123        |
    Then bör svaret ha statuskod 200
    And bör svaret innehålla en giltig JWT-token
    And bör användarsessionen sparas
```

### Exempel: Webbgränssnitt

```gherkin
Feature: Webbplatsnavigation

  @ui @smoke
  Scenario: Användare navigerar till produktsida
    Given jag är på hemsidan
    When jag klickar på navigeringsmenyn
    And jag väljer "Produkter" från menyn
    Then bör jag se produktsidan
    And bör URL:en vara "/produkter"
    And bör sidan visa produktlistan
```

## Skapa Steg-definitioner

### Grundläggande mönster

```javascript
const { Given, When, Then, And, But } = require('@cucumber/cucumber');
const assert = require('assert');

// Synkrona steg
Given('en registrerad användare med epost {string}', function (email) {
  this.user = { email, verified: true };
});

// Med regex för datatyper
When('jag skickar en POST-förfrågan till {string}', async function (endpoint) {
  const response = await fetch(this.baseUrl + endpoint, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(this.requestBody || {})
  });
  this.response = response;
  this.responseStatus = response.status;
  this.responseBody = await response.json();
});

// Använda tabell-data
Then('svaret bör innehålla:', function (table) {
  const expected = table.rowsHash();
  for (const [key, value] of Object.entries(expected)) {
    assert.strictEqual(this.responseBody[key], value, 
      `Förväntade ${key}="${value}", fick "${this.responseBody[key]}"`);
  }
});
```

### Data Tables

```javascript
// För tabeller med kolumnrubriker
Given('jag har följande produkter:', function (dataTable) {
  this.products = dataTable.hashes().map(row => ({
    id: row.id,
    name: row.namn,
    price: parseFloat(row.pris)
  }));
});

// För tabeller utan rubriker (horisontell layout)
When('jag konfigurerar:', function (dataTable) {
  const rows = dataTable.rows();
  this.config = {
    setting1: rows[0][1],
    setting2: rows[1][1]
  };
});
```

### Doc Strings (flerradig text)

```javascript
When('jag skickar en förfrågan med body:', async function (docString) {
  const body = JSON.parse(docString);
  this.response = await fetch('/api/data', {
    method: 'POST',
    body: JSON.stringify(body)
  });
});
```

### World-koncept (delad kontext)

```javascript
// tests/features/support/world.js
const { World } = require('@cucumber/cucumber');

class ApiWorld extends World {
  constructor(options) {
    super(options);
    this.baseUrl = process.env.API_URL || 'http://localhost:3000';
    this.response = null;
    this.responseBody = null;
  }

  async sendRequest(method, endpoint, body = {}) {
    this.response = await fetch(this.baseUrl + endpoint, {
      method,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body)
    });
    this.responseBody = await this.response.json();
    return this.response;
  }
}

module.exports = { ApiWorld };
```

## Hooks (life-cycle)

```javascript
// tests/features/support/hooks.js
const { Before, After, BeforeAll, AfterAll, AfterStep } = require('@cucumber/cucumber');

BeforeAll(async function () {
  // Körs en gång innan alla scenarier
  console.log('Startar test-suite...');
});

Before(async function (scenario) {
  // Körs före varje scenario
  this.testData = { id: generateId() };
  await setupTestEnvironment();
});

After(async function (scenario) {
  // Körs efter varje scenario (oavsett outcome)
  if (scenario.result.status === 'FAILED') {
    await takeScreenshot(this.driver);
  }
  await cleanupTestData();
});

AfterStep(async function ({ pickle, result }) {
  // Körs efter varje steg
  if (result.exception) {
    console.error(`Steg misslyckades: ${pickle.steps[-1].text}`);
  }
});

AfterAll(async function () {
  // Städa upp efter alla tester
  await closeBrowser();
});
```

## Cucumber-konfiguration

### cucumber.js (tests/-mapp)

```javascript
// tests/cucumber.js
const common = require('./features/support/world');

module.exports = {
  default: {
    format: ['progress-bar', 'html:reports/cucumber-report.html'],
    paths: ['features/**/*.feature'],
    import: ['features/support/**/*.js', 'features/step_definitions/**/*.js'],
    parallel: 4,
    requireModule: ['ts-node/register'],
    worldParameters: {
      appUrl: process.env.APP_URL || 'http://localhost:8080'
    }
  }
};
```

### package.json (hanteras med bun)

```json
{
  "name": "bdd-tests",
  "version": "1.0.0",
  "scripts": {
    "test": "cucumber-js",
    "test:report": "cucumber-js --format html:reports/cucumber.html",
    "test:parallel": "cucumber-js --parallel 4",
    "test:tags": "cucumber-js --tags '@smoke'"
  },
  "devDependencies": {
    "@cucumber/cucumber": "^11.0.0",
    "@cucumber/pretty-formatter": "^1.0.0"
  }
}
```

## Kom igång

1. **Skapa tests-mappen** i aktuellt repo:
   ```bash
   mkdir -p tests/features/{step_definitions,support}
   ```

2. **Initiera med bun**:
   ```bash
   bun add -d @cucumber/cucumber @cucumber/pretty-formatter
   ```

3. **Skapa cucumber.js** och börja skriva features!

## Best Practices

### Gherkin-regler

1. **Svara på "vem, vad och varför"** - Background och Scenario Outline ska
   tydligt svara på dessa frågor
2. **Undvik teknisk jargong** - Använd affärs- och domäntermer
3. **Ett scenario, en resa** - Varje scenario ska testa en specifik väg
4. **Undvik "And" i början** - Börja med Given/When/Then
5. **Konsekvent språk** - Svenska eller engelska, blanda inte

### Stegdefinitionsregler

1. **Återanvändbara steg** - Skriv generiska steg som kan återanvändas
2. **Tydliga felmeddelanden** - Ge kontext i assert-meddelanden
3. **Async/await** - Använd async funktioner för HTTP/IO
4. **World för delad kontext** - Använd World-klassen för att dela state

### Filorganisering

```
tests/features/
├── api/                      # API-tester
│   ├── auth.feature
│   └── users.feature
├── ui/                       # UI-tester
│   ├── navigation.feature
│   └── forms.feature
└── integration/              # Integrationstester
    └── checkout.feature
```

## Arbetsflöde

### För BDD/Gherkin-tester: Följ alltid Red-Green-Refactor

```
┌─────────────────────────────────────────────────────────────────────────────┐
│          🔴🟢♻️ TDD-cykeln för BDD med FRÅGA-INNAN-EDIT                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   🔴 RED (Steg 1)              🟢 GREEN (Steg 2)        ♻️ REFACTOR (Steg 3) │
│   ┌───────────────────┐       ┌───────────────────┐   ┌───────────────────┐ │
│   │ 1. Designa med    │       │ 1. Föreslå impl.  │   │ 1. Föreslå ändr.  │ │
│   │    användaren     │       │ 2. ❓ Fråga:       │   │ 2. ❓ Fråga:       │ │
│   │ 2. ❓ Fråga:       │ ────▶ │    "Vill du?"     │──▶│    "Vill du?"     │ │
│   │    "Vill du?"     │       │ 3. Vid ja: edit   │   │ 3. Vid ja: edit   │ │
│   │ 3. Vid ja: edit   │       │ 4. Kör test       │   │ 4. Kör test       │ │
│   │ 4. Kör test       │       │ 5. Ska passera    │   │ 5. Ska passera    │ │
│   │ 5. Ska misslyckas │       │    (GREEN)        │   │    (grönt)        │ │
│   └───────────────────┘       └───────────────────┘   └───────────────────┘ │
│                                         │                                   │
│                                         ▼                                   │
│                                🔄 UPREPA för nästa scenario                  │
└─────────────────────────────────────────────────────────────────────────────┘
```

**⚠️ GOLDEN REGLER:**
1. **❓ Fråga ALLTID innan edit** — "Vill du att jag gör X?"
2. **💡 Förklara alltid varför** — "Detta scenario behövs för att..."
3. **⏳ Vänta på svar** — Editar ALDRIG utan bekräftelse
4. **📝 Visa alltid sammanfattning** — "Så här ser det ut... Är det korrekt?"

**Detaljerat arbetsflöde:**

1. **Analysera kravet** - Förstå vilken funktionalitet som ska testas
2. **Designa Gherkin-scenariot** - Interaktiv Given-When-Then med användaren
3. **🔴 RED: Skriv Gherkin + tomma steg-definitioner**
   - **❓ Fråga:** "Vill du att jag lägger till detta scenario?"
   - **💡 Förklara:** "Detta scenario behövs för att täcka edge case X..."
   - Vid bekräftelse: Skapa feature-filen med scenariot
   - Skriv steg-definitioner som kastar `Pending` eller `undefined`
   - Kör `bun test` → **Verifiera att testet misslyckas**
4. **🟢 GREEN: Implementera minimalt (med mock/state)**
   - **❓ Fråga:** "Vill du att jag implementerar steg-definitionerna?"
   - **💡 Förklara:** "Jag behöver lägga till implementation för att..."
   - Vid bekräftelse: Skriv minimal kod för att testerna ska passera
   - Använd mock-state för att komma vidare snabbt
   - Kör `bun test` → **Verifiera att testet passerar**
5. **♻️ REFACTOR: Uppdatera steg-definitioner**
   - **❓ Fråga:** "Vill du att jag refaktorerar koden?"
   - **💡 Förklara:** "Jag föreslår att byta ut mock mot riktiga API:er för att..."
   - Vid bekräftelse: **Uppdatera steg-definitioner**
     - Byt ut mock-state mot riktiga API-anrop (`fetch()`)
     - Anslut till UI med Playwright/Cypress-selektorer
     - Dela upp i Page Objects, extrahera helpers
   - Kör `bun test` → **Verifiera att testet fortfarande passerar**
6. **Upprepa** - Börja om från steg 1 för nästa scenario

### För enhetstester: Samma princip

```
1. Skriv testet → Ska misslyckas (RED)
2. Skriv minimal kod → Ska passera (GREEN)  
3. Refaktorera → Fortfarande grönt (REFACTOR)
```

---

## Avancerade Exempel

### API-testning med fetch

```gherkin
Feature: REST API

  @api
  Scenario: Hämta data från API
    Given API:t är tillgängligt på "https://api.example.com"
    When jag skickar en GET-förfrågan till "/users/1"
    Then bör svaret ha statuskod 200
    And bör svaret innehålla:
      | field   | value     |
      | id      | 1         |
      | name    | TestUser  |

  @api
  Scenario: Skapa resurs med POST
    Given jag har payload:
      """
      {
        "name": "Ny användare",
        "email": "ny@example.com"
      }
      """
    When jag skickar en POST-förfrågan till "/users"
    Then bör svaret ha statuskod 201
    And bör svaret innehålla "id"
```

```javascript
// API-steg-definitioner
When('jag skickar en GET-förfrågan till {string}', async function (path) {
  const response = await fetch(this.baseUrl + path);
  this.responseStatus = response.status;
  this.responseBody = await response.json();
});

When('jag skickar en POST-förfrågan till {string}', async function (path) {
  const response = await fetch(this.baseUrl + path, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: this.requestPayload
  });
  this.responseStatus = response.status;
  this.responseBody = await response.json();
});

Then('bör svaret ha statuskod {int}', function (expected) {
  if (this.responseStatus !== expected) {
    throw new Error(`Förväntad status ${expected}, fick ${this.responseStatus}`);
  }
});

Given('jag har payload:', function (docString) {
  this.requestPayload = docString;
});
```

### Databashantering

```gherkin
Feature: Databasoperationer

  Scenario: Spara och hämta data
    Given databasen är tom
    When jag sparar en användare "test@example.com"
    And jag väntar 100ms
    Then borde användaren "test@example.com" finnas i databasen
```

```javascript
const db = require('./support/database');

Given('databasen är tom', async function () {
  await db.clearAll();
});

When('jag sparar en användare {string}', async function (email) {
  this.savedUser = await db.users.create({ email });
});

Then('borde användaren {string} finnas i databasen', async function (email) {
  const user = await db.users.findByEmail(email);
  if (!user) {
    throw new Error(`Användare ${email} hittades inte`);
  }
});
```

### Filhantering

```gherkin
Feature: Filoperationer

  Scenario: Skapa och läsa fil
    Given jag har en tom arbetskatalog
    When jag skapar en fil "test.txt" med innehållet "Hello World"
    And jag läser filen "test.txt"
    Then borde filens innehåll vara "Hello World"
```

```javascript
const fs = require('fs/promises');
const path = require('path');

Given('jag har en tom arbetskatalog', async function () {
  this.workDir = await fs.mkdtemp(path.join('/tmp', 'cucumber-'));
});

When('jag skapar en fil {string} med innehållet {string}', async function (filename, content) {
  const filePath = path.join(this.workDir, filename);
  await fs.writeFile(filePath, content);
});

When('jag läser filen {string}', async function (filename) {
  const filePath = path.join(this.workDir, filename);
  this.fileContent = await fs.readFile(filePath, 'utf-8');
});

Then('borde filens innehåll vara {string}', function (expected) {
  if (this.fileContent !== expected) {
    throw new Error(`Förväntat "${expected}", fick "${this.fileContent}"`);
  }
});
```

### Webhook-hantering

```gherkin
Feature: Webhooks

  Scenario: Ta emot webhook
    Given jag har startat en webhook-mottagare på port 3001
    When en POST-förfrågan skickas till webhooen med:
      | field   | value        |
      | event   | user.created |
      | data    | {"id": 1} |
    Then borde webhook-mottagaren ha tagit emot händelsen
    And borde händelsetypen vara "user.created"
```

### Felhantering

```gherkin
@error
Scenario: Hantera API-fel
  Given API:t är tillgängligt
  When jag skickar en ogiltig förfrågan
  Then borde jag få statuskod 400
  And borde felmeddelandet innehålla "validation error"
  But borde INGEN data sparas
```

```javascript
// Felhanteringssteg
When('jag skickar en ogiltig förfrågan', async function () {
  try {
    await fetch(`${this.baseUrl}/invalid`, { method: 'POST' });
  } catch (e) {
    this.caughtError = e;
  }
});

Then('borde INGEN data sparas', async function () {
  const count = await db.count();
  if (count > 0) {
    throw new Error('Data sparades trots ogiltig förfrågan');
  }
});
```

---

---

## Enhetstester: Jest / Vitest

### Grundstruktur (Jest)

```javascript
// tests/unit/calculateSum.test.js
const { calculateSum } = require('../../src/math');

describe('calculateSum', () => {
  it('ska returnera summan av två tal', () => {
    expect(calculateSum(2, 3)).toBe(5);
  });

  it('ska hantera negativa tal', () => {
    expect(calculateSum(-1, -1)).toBe(-2);
  });

  it('ska kasta fel vid invalid input', () => {
    expect(() => calculateSum('a', 1)).toThrow('Invalid input');
  });
});
```

### Mocks och Spies

```javascript
const { vi } = require('vitest');

// Mocka en funktion
const mockFetch = vi.fn();
global.fetch = mockFetch;

mockFetch.mockResolvedValue({
  ok: true,
  json: () => Promise.resolve({ id: 1, name: 'Test' })
});

// Använd i test
const result = await fetchUser(1);
expect(result.name).toBe('Test');
expect(mockFetch).toHaveBeenCalledWith('/users/1');
```

### Testa async kod

```javascript
it('ska hämta data asynkront', async () => {
  const data = await fetchData();
  expect(data).toEqual({ items: [] });
});

it('ska hantera fetch-fel', async () => {
  mockFetch.mockRejectedValue(new Error('Network error'));
  await expect(fetchData()).rejects.toThrow('Network error');
});
```

### Parametriserade tester

```javascript
// Jest
test.each([
  [2, 3, 5],
  [0, 0, 0],
  [-1, 1, 0]
])('calculateSum(%d, %d) = %d', (a, b, expected) => {
  expect(calculateSum(a, b)).toBe(expected);
});

// Vitest
test.each([
  { a: 2, b: 3, expected: 5 },
  { a: 0, b: 0, expected: 0 }
])('calculateSum($a, $b) = $expected', ({ a, b, expected }) => {
  expect(calculateSum(a, b)).toBe(expected);
});
```

---

## Integrationstester: Cypress

### Grundstruktur

```javascript
// tests/cypress/e2e/login.cy.js
describe('Inloggning', () => {
  beforeEach(() => {
    cy.visit('/login');
  });

  it('ska logga in med giltiga uppgifter', () => {
    cy.get('[data-testid="email-input"]').type('test@example.com');
    cy.get('[data-testid="password-input"]').type('password123');
    cy.get('[data-testid="login-button"]').click();
    
    cy.url().should('include', '/dashboard');
    cy.contains('Välkommen').should('be.visible');
  });

  it('ska visa felmeddelande vid fel lösenord', () => {
    cy.get('[data-testid="email-input"]').type('test@example.com');
    cy.get('[data-testid="password-input"]').type('fel_losenord');
    cy.get('[data-testid="login-button"]').click();
    
    cy.contains('Felaktigt lösenord').should('be.visible');
    cy.url().should('include', '/login');
  });
});
```

### API-testing i Cypress

```javascript
it('ska skapa användare via API', () => {
  cy.request({
    method: 'POST',
    url: '/api/users',
    body: {
      email: 'ny@example.com',
      password: 'sakerLösen'
    }
  }).then((response) => {
    expect(response.status).to.eq(201);
    expect(response.body).to.have.property('id');
  });
});
```

### Fixtures och Mocking

```javascript
// Ladda fixture-data
cy.fixture('user.json').then((user) => {
  cy.get('[data-testid="email-input"]').type(user.email);
});

// Stubba nätverksförfrågningar
cy.intercept('GET', '/api/users', { fixture: 'users.json' }).as('getUsers');
cy.visit('/users');
cy.wait('@getUsers');
```

---

## E2E-tester: Playwright

### Grundstruktur

```javascript
// tests/e2e/checkout.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Checkout-flöde', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/products');
  });

  test('ska slutföra ett köp', async ({ page }) => {
    // Lägg till produkt i varukorgen
    await page.click('[data-testid="add-to-cart-1"]');
    await expect(page.locator('.cart-count')).toHaveText('1');
    
    // Gå till kassan
    await page.click('[data-testid="checkout-button"]');
    await expect(page).toHaveURL(/\/checkout/);
    
    // Fyll i uppgifter
    await page.fill('[data-testid="email"]', 'kund@example.com');
    await page.fill('[data-testid="card-number"]', '4242424242424242');
    
    // Slutför köp
    await page.click('[data-testid="pay-button"]');
    await expect(page.locator('.success-message')).toBeVisible();
  });

  test('ska validera formulär', async ({ page }) => {
    await page.click('[data-testid="checkout-button"]');
    await page.click('[data-testid="pay-button"]');
    
    await expect(page.locator('[data-testid="email-error"]'))
      .toContainText('Epost är obligatoriskt');
  });
});
```

### API-testing i Playwright

```typescript
test('ska skapa användare via API', async ({ request }) => {
  const response = await request.post('/api/users', {
    data: {
      email: 'ny@example.com',
      password: 'sakerLösen'
    }
  });
  
  expect(response.ok()).toBeTruthy();
  expect(response.status()).toBe(201);
  const body = await response.json();
  expect(body).toHaveProperty('id');
});
```

### Page Object Pattern

```typescript
// tests/e2e/pages/LoginPage.ts
export class LoginPage {
  constructor(page) {
    this.page = page;
    this.emailInput = page.locator('[data-testid="email-input"]');
    this.passwordInput = page.locator('[data-testid="password-input"]');
    this.loginButton = page.locator('[data-testid="login-button"]');
    this.errorMessage = page.locator('[data-testid="error-message"]');
  }

  async login(email, password) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.loginButton.click();
  }

  async expectError(message) {
    await expect(this.errorMessage).toContainText(message);
  }
}

// Använd i test
test('ska visa fel vid felaktig inloggning', async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.login('fel@example.com', 'fel');
  await loginPage.expectError('Felaktiga uppgifter');
});
```

---

## Val av testtyp

| Typ | Använd när | Ramverk |
|-----|------------|---------|
| **Enhetstest** | Testa en enskild funktion/komponent i isolering | Jest, Vitest, Mocha |
| **Integrationstest** | Testa hur flera delar samverkar | Cypress, Playwright, Jest |
| **E2E-test** | Testa hela flöden från användarens perspektiv | Playwright, Cypress |
| **BDD/Gherkin** | Beskriv affärsbeteende i plain language | Cucumber.js |
| **API-test** | Testa backend-endpoints direkt | Jest, Supertest, Postman |

### Mappstruktur rekommendation

```
<current-repo>/tests/
├── unit/                    # Enhetstester
│   └── *.test.js
├── integration/             # Integrationstester
│   └── *.cy.js             # Cypress
├── e2e/                    # E2E-tester
│   └── *.spec.ts           # Playwright
├── api/                    # API-tester
│   └── *.test.js
└── features/                # BDD/Gherkin
    ├── *.feature
    └── step_definitions/
```

## Snabbreferens: Gherkin-mall

```gherkin
Feature: [Kort beskrivning]

  Som [roll]
  Vill jag [funktion]
  För att [nytta/värde]

  Background:
    Given [delad förutsättning]

  @tag1 @tag2
  Scenario: [Beskrivning]
    Given [förutsättning]
    And [mer förutsättning]
    When [handling]
    And [mer handling]
    Then [förväntat resultat]
    But [negerat resultat]

  @tag
  Scenario Outline: [Beskrivning med parametrar]
    Given jag har <input>
    When jag <action>
    Then borde <output>

    Examples: [Namn]
    | input | action | output |
    | x     | y      | z      |
```

---

## 🎯 EXEMPEL-KATALOG: Vanliga scenarier

### E-handel / Varukorg

```gherkin
Feature: Handla i nätbutik

  Som kund
  Vill jag kunna handla produkter
  För att slippa gå till fysisk butik

  @smoke
  Scenario: Lägga till produkt i varukorgen
    Given Sara är på en produktsida
    When Sara klickar på "Lägg i varukorgen"
    Then varukorgen ska visa produkten med priset 299 kr

  Scenario: Ta bort produkt från varukorgen
    Given Soras varukorg innehåller en produkt
    When Sara tar bort produkten
    Then varukorgen ska vara tom

  Scenario: Köpa flera produkter
    Given Sara har lagt till 3 produkter i varukorgen
    When Sara går till kassan
    Then Sara ska se totalpriset

  Scenario Outline: Köpa med olika betalsätt
    Given Sara har produkter i varukorgen
    When Sara betalar med <betalningssätt>
    Then köpet ska genomföras

    Examples: Betalsätt
    | betalningssätt |
    | kort           |
    | Swish          |
    | faktura        |
```

### Användarregistrering

```gherkin
Feature: Skapa konto

  Som ny besökare
  Vill jag kunna skapa ett konto
  För att kunna handla och spara mina uppgifter

  @smoke
  Scenario: Registrera ny användare
    Given Anna är på registreringssidan
    When Anna fyller i giltig epost och lösenord
    And Anna klickar på "Skapa konto"
    Then Anna ska få ett bekräftelsemejl
    And Anna ska vara inloggad

  Scenario: Registrering med ogiltig epost
    Given Anna är på registreringssidan
    When Anna försöker registrera sig med epost som redan finns
    Then Anna ska få meddelande om att eposten är upptagen

  Scenario: Registrering med svagt lösenord
    Given Anna är på registreringssidan
    When Anna väljer ett lösenord som är för kort
    Then Anna ska få veta vilka krav som gäller för lösenord
```

### Söka och filtrera

```gherkin
Feature: Söka produkter

  Som kund
  Vill jag kunna söka och filtrera produkter
  För att hitta det jag letar efter snabbt

  Scenario: Söka efter produkt
    Given Maria är på hemsidan
    When Maria söker efter "röd tröja"
    Then Maria ska se alla produkter som matchar sökningen

  Scenario: Filtrera på pris
    Given Sökresultaten visar 50 produkter
    When Maria filtrerar på pris 200-500 kr
    Then Maria ska bara se produkter inom det prisintervallet
    And antalet produkter ska minska

  Scenario: Filtrera på storlek
    Given Produkterna finns i flera storlekar
    When Erik filtrerar på storlek "L"
    Then Erik ska bara se produkter i storlek L
```

### Profilhantering

```gherkin
Feature: Hantera sin profil

  Som registrerad användare
  Vill jag kunna ändra mina uppgifter
  För att hålla min information uppdaterad

  Scenario: Ändra epostadress
    Given Olle är inloggad på sitt konto
    When Olle ändrar sin epost till "ny@epost.se"
    Then nya eposten ska sparas
    And Olle ska få bekräftelse på ändringen

  Scenario: Ändra lösenord
    Given Olle är inloggad
    When Olle anger nuvarande och nytt lösenord
    Then det nya lösenordet ska gälla
    And Olle ska fortfarande vara inloggad
```

---

## 🚫 UNDVIK DESSA MISSTAG

### ❌ För många steg
```gherkin
# DÅLIGT - 12 steg, svårt att följa
Scenario: Komplext köp
  Given jag har lagt till produkter
  And jag har klickat på varukorgen
  And jag har klickat på köp
  And jag har fyllt i address
  When jag klickar på fortsätt
  And jag väljer betalsätt
  And jag fyller i kortuppgifter
  And jag klickar på betala
  Then köpet ska vara klart
```

```gherkin
# BRA - Fokuserat, max 4-5 steg
Scenario: Slutföra köp
  Given Anna har produkter i varukorgen
  When Anna betalar med kort
  Then köpet ska vara genomfört
```

### ❌ Tekniska detaljer
```gherkin
# DÅLIGT - URL:er, fält-ID, teknisk jargong
Scenario: Teknisk inloggning
  Given I am on the "/login" page
  When I fill "user_email" with "test@test.com"
  And I fill "user_password" with "pass123"
  And I click the #login-btn
  Then I should be redirected to "/dashboard"
```

```gherkin
# BRA - Användarcentrerat, affärsspråk
Scenario: Emma loggar in
  Given Emma har ett konto
  When Emma loggar in
  Then Emma ska se sin dashboard
```

### ❌ Otydliga förväntade resultat
```gherkin
# DÅLIGT - Vad förväntas hända?
Then systemet ska svara
```

```gherkin
# BRA - Tydligt resultat
Then beställningen ska bekräftas med ett ordernummer
```
