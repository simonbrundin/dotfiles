---
name: clean-code
description: >-
  Refaktorera kod och förbättra kodkvalitet med Robert C. Martins Clean Code-principer.

  ANVÄND DENNA SKILL när användaren ber om:
  - Refaktorering, omstrukturering eller uppdelning av kod
  - Förbättring av kodstruktur, namngivning eller läsbarhet
  - Tillämpning av SOLID, Single Responsibility eller Clean Code-principer
  - Uppdelning av långa funktioner, klasser eller filer
  - Borttagning av kodlukt, duplicering eller komplexitet
  - Test-first, TDD eller ren felhantering
  - Martin Fowler-refaktorering (extract method, rename, etc.)
  - Kodgranskning för kvalitet eller strukturella förbättringar
  - Granska ändringar som inte pushats ännu (unstaged, staged, unpushed commits)

  Utlösande ord/fraser: "refaktorera", "clean code", "förbättra", "bryt upp",
  "granska mina ändringar", "unstaged", "unpushed", "kodlukt", "SOLID",
  "duplicering", "TDD", "test-first", "namngivning", "extract method",
  "single responsibility", "code smell", "lång funktion", "code review".
---

# Clean Code — Robert C. Martin

Denna skill distillerar Robert C. Martins _Clean Code: A Handbook of Agile
Software Craftsmanship_ till operativa regler. Den gäller för all kod du skriver,
ändrar eller granskar.

Om det finns spänning mellan hastighet och renhet, välj den rena lösningen om
det inte finns en påvisad operativ nödsituation. Om en genväg är oundviklig,
isolera den, gör den uppenbar, och lämna koden i ett tillstånd som kan
städas upp säkert senare.

Läs [reference.md](reference.md) för utökad vägledning, exempel och
designheuristik.

---

## De Tre Lagren av Ren Kod

Innan du börjar, förstå de tre kriterierna som alltid gäller:

| Lag | Fråga |Definition |
|-----|-------|-----------|
| **Korrekthet** | Fungerar koden? | Logiskt korrekt,alla edges hanterade |
| **Läsbarhet** | Är koden begriplig? | Namn avslöjar avsikt, ingen dold magi |
| **Struktur** | Är designen bra? | Små enheter, låg koppling, hög kohesion |

**Definition of Done:** En uppgift är KLAR först när alla tre lagren är
uppfyllda.

---

## Kärnregler

### 1. Lämna koden renare

Varje ändring måste förbättra minst en av: klarhet, namngivning, enkelhet,
kohesion, testbarhet, felhantering, borttagning av duplicering, eller
separering av concerns. Lägg aldrig till kod som bara är funktionell —
lägg till kod som är förståelig.

> "Leave the campground cleaner than you found it." — Robert C. Martin

### 2. Använd intention-avslöjande namn

- Namn ska svara på **vad** det är, **varför** det finns, och **hur** det
  används.
- Undvik svaga namn: `data`, `info`, `thing`, `stuff`, `process`, `manager`,
  `helper`, `util`, `temp`, `value`, `obj`, `handle`. Använd endast dessa om
  de är genuint korrekta i domänen.
- Booleska variabler: prefixa med `is`, `has`, `can`, `should` eller suffixa
  med `?` (språkanpassat).
- Samlingar: pluralisera (`users`, `orderItems`).
- Funktioner: beskriv handlingen, inte vag aktivitet.
  - ✅ `calculateInvoiceTotal`, `loadWorkspaceSettings`, `enqueueRetry`
  - ❌ `doInvoice`, `handleSettings`, `processData`
- Funktioner som returnerar bool: frågeform. `isActive`, `hasItems`,
  `userCanPublish`.
- Klassenamn: substantiv/fras, inte verb. `InvoiceCalculator`, inte
  `CalculateInvoice`.

### 3. Håll funktioner små och fokuserade

- En funktion ska göra **en sak**, göra den **väl**, och göra den **endast**.
- **Ett anropsdjup** av indentering max.
- **Inga sidoeffekter** (eller gör dem explicita i namnet).
- Parametrar: 0, 1, eller 2. Tre triggar granskning. Fler = saknad
  datastruktur.
- **Aldrig boolean-parametrar** för att byta beteende.
  - ✅ `renderPublicProfile(user)` + `renderPrivateProfile(user)`
  - ❌ `renderProfile(user, includePrivate: true)`
- Extrahera när funktionen har flera "avsnitt" (parsa → validera → spara →
  svara).

#### Funktioners längd — Robert Martins tumregler

| Mått | Maxlängd | Kommentar |
|------|----------|----------|
| **Funktion** | ~20 rader | "Hardly ever be 20 lines long" |
| **Funktion** | < 100 rader | Aldrig nå 100 — refaktorera!
| **Fil/Klass** | ~200 rader | Tumregel enligt Clean Code |
| **Fil/Klass** | 100–200 rader | "Sweet spot" |
| **Fil/Klass** | > 500 rader | 🚨 Varningstecken — dela upp |

> "The first rule of functions is that they should be small. The second rule
> is that functions should be smaller than that." — Robert C. Martin

**När är en fil för lång?** Om filen:
- Har flera tydliga ansvarsområden (t.ex. både datamodell OCH affärslogik)
- Kräver scrollning för att förstå helheten
- Har > 10 publika metoder
- Manipulerar mer än en entitet
→ **Dela upp den.**

### 4. Separera abstraktionsnivåer

- Blanda inte högnivåpolitik med lågnivåmekanik.
- Håll orchestration separat från implementationsdetaljer.
- Domänlogik separat från I/O, ramverk, serialisering.
- Varje funktion: en nivå av abstraktion, från hög till låg.

```python
# ❌ Blandar nivåer
def process_order(order):
    total = sum(item.price for item in order["items"])  # låg
    if total > 1000:  # hög (business rule)
        send_email(order["email"])  # låg/I/O
    save_to_db(order)  # låg/I/O
    return {"total": total, "status": "processed"}

# ✅ Ren separation
def calculate_order_total(items):        # låg
def apply_discount_if_eligible(total):  # hög (domain)
def notify_customer(email, total):      # låg/I/O
def persist_order(order):              # låg/I/O
```

### 5. Gör sidoeffekter explicita

- Funktioner som returnerar data ska **inte** samtidigt ändra state.
- Om en funktion har sidoeffekter, avslöja det i namnet:
  - `calculateTotal()` — ren beräkning
  - `saveUserAndNotify()` — sidoeffekt i namnet
- Undvik hidden mutation. Undvik implicita globals.
- Föredra explicit beroende framför global state.

### 6. Använd guard clauses

Ersätt djup nästling med tidigare return:

```typescript
// ❌ Djup nästling
function processOrder(order: Order) {
  if (order.isValid) {
    if (order.items.length > 0) {
      if (currentUser.canPlaceOrders) {
        // gör jobbet
      }
    }
  }
}

// ✅ Guard clauses
function processOrder(order: Order) {
  if (!order.isValid) return;
  if (order.items.length === 0) return;
  if (!currentUser.canPlaceOrders) return;
  // gör jobbet
}
```

### 7. Behandla fel som design

- **Fail fast** på invalida antaganden.
- Använd exceptions, inte retur-koder.
- Skriv `try-catch-finally` först, fyll i body senare.
- Ge felmeddelanden som hjälper en framtida ingenjör att diagnostisera.
- Behåll happy path läsbar.
- Blanda inte valideringsfel, domänfel och infrastrukturfel utan anledning.

```typescript
// ❌ Swallow + returning magic value
function parseConfig(raw: string) {
  try {
    return JSON.parse(raw);
  } catch {
    return null; // vad gick fel??
  }
}

// ✅ Fail fast med kontext
function parseConfig(raw: string): Config {
  try {
    return JSON.parse(raw) as Config;
  } catch (e) {
    throw new ConfigError(`Failed to parse config: ${raw.slice(0, 100)}`, e);
  }
}
```

### 8. Behåll moduler och klasser kohesiva

- **Single Responsibility Principle**: varje enhet har en, och endast en,
  anledning att förändras.
- Håll publika ytor små.
- Undvik "god objects" som gör allt.
- Föredra komposition framför ärvd.
- Om du inte kan beskriva vad klassen gör i en mening → dela upp den.

### 9. Ta bort duplicering på rätt nivå

- Ta bort duplicerad affärslogik, beslut, affärsregler och meningsfulla
  litteraler.
- **Duplicering av kod** = möjlig refaktorering.
- **Duplicering av affärsregler** = teknisk skuld.
- **VARNING:** Hitta inte abstraktioner för tidigt. "Two things are the same
  only when they are identical in every relevant way." — Fowlers lag.

### 10. Arbeta test-first (TDD som standard)

- För ny funktionalitet, buggfixar, och beteendeändringar: skriv misslyckat
  test **först**.
- **Röd-grön-refaktorera**: Röd (test fail) → Grön (minimal fix) →
  Refaktorera (förbättra struktur utan att ändra beteende).
- Testa **beteende**, inte implementationsdetaljer.
- Tester ska vara: läsbara, deterministiska, oberoende av ordning, namngivna
  efter förväntat resultat.
- Lägg till regressionstester **innan** du fixar en bugg.

### 11. Refaktorera kontinuerligt

- Refaktorera **när du arbetar** — inte i en separat "cleanup-fas".
- Behåll tester gröna under refaktorering.
- Små steg, verifiera efter varje.
- Om en fullständig rensning är utanför scope: förbättra den närmaste
  meningsfulla gränsen och lämna en tydlig anteckning.

**Refaktoreringar att känna till** (Martin Fowler):

| Namn | När |
|------|-----|
| Extract Method | Funktion > 10 rader eller flera abstraktionsnivåer |
| Rename Variable | Namn avslöjar inte avsikt |
| Extract Variable | Cached uttryck för läsbarhet |
| Introduce Parameter Object | För många parametrar |
| Replace Conditional with Polymorphism | Switch/if-kedjor per typ |
| Move Method | Metod bor på fel ställe |
| Inline Method | Metod gör enbart delegation |
| Substitute Algorithm | Enklare algoritm existerar |
| Introduce Assertion | Antagande bör göras explicit |
| Split Loop | Loop gör flera saker |

### 12. Respektera SOLID-principerna

- **S**ingle Responsibility: en anledning att förändras
- **O**pen/Closed: öppen för extension, stängd för modifiering
- **L**iskov Substitution: subtypes substituerbara för basetyper
- **I**nterface Segregation: små, specifika interfaces
- **D**ependency Inversion: beror på abstraktioner, inte konkretioner

Applicera SOLID när du designar nya klasser/interfaces. Refaktorera mot SOLID
när kod blir svår att ändra.

### 13. Isoler extern kod

- Databaser, API:er, filsystem, köer, ramverk: isolera bakom tydliga gränser.
- Översätt extern data till interna representationer.
- Håll ramverksspecifik kod borta från domänen.
- **Repository-mönstret**: databasåtkomst bakom interface.
- **Adapter-mönstret**: externa API:er bakom internt gränssnitt.

### 14. Enkelhet först

- Föredra den enklaste design som korrekt stödjer beteendet.
- **YAGNI**: Bygg inte extensibility bara för säkerhets skull.
- Ta bort ackumulerad komplexitet.
- "Simple does not mean crude. It means there are no unnecessary parts."

---

## Refaktoreringsarbetsflöde

Följ dessa steg för systematisk refaktorering:

```
1. IDENTIFIERA    → Använd "Red Flags" nedan för att hitta problem
2. VERIFIERA       → Se till att tester finns och passerar innan du börjar
3. REFAKTORERA    → Gör EN liten förändring i taget
4. VERIFIERA       → Kör tester efter varje steg
5. COMMITA         → Commita efter varje lyckad refaktorering
6. REPETERA        → Nästa lilla förbättring
```

---

## Röda Flaggor — Stopp och Refaktorera

Stoppa och ompröva när du ser:

| Symptom | Möjlig Refaktorering |
|---------|---------------------|
| Metod med flera "avsnitt" | Extract Method |
| **Metod > 20 rader** | Extrahera delfunktioner |
| **Fil/Klass > 200 rader** | Split efter ansvarsområde |
| **Fil/Klass > 500 rader** | 🚨 Brådskande uppdelning |
| Filnamn med "And" (t.ex. `UserAndOrderService`) | Dela i två klasser |
| Boolean-parameter | Split till två metoder |
| Kommentarer som förklarar förvirrande kod | Rename + Extract Method |
| Upprepade if/switch över flera filer | Replace Conditional with Polymorphism |
| Vaga modulnamn | Rename Module / Move Method |
| Hidden dependencies | Introduce Parameter Object |
| Metod som både muterar och svarar | Split Query from Command |
| Lång parameterlista | Introduce Parameter Object |
| Bred catch-all felhantering | Narrow exception types |
| Utility-namespace med orelaterad kod | Move Method till rätt klass |
| Anemi (klass med data men inget beteende) | Move Method hit, behavior with data |

---

## Beslutheuristik

När flera designalternativ är möjliga, föredra det som:

1. Är enklast att förklara för en annan ingenjör
2. Håller ansvarsområden separerade
3. Minimerar hidden state och sidoeffekter
4. Är enklast att testa
5. Tar bort duplicering utan att uppfinna instabila abstraktioner
6. Bevarar flexibilitet genom klarhet snarare än indirection

---

## Kommentarer

**Godkända kommentarer:**
- Juridisk information
- Varningar om överraskande externa begränsningar
- Kort motivering för icke-uppenbar tradeoff
- Intent som inte kan uttryckas rent i kod
- Specifika, handlingsbara TODOs

**Förbjudna kommentarer:**
- Kod upprepas i prosa
- Missvisande kommentarer
- Utkommenterad kod
- Förklaringar som kompenserar för dålig namngivning
- Stora förklaringsblock över rörig kod som borde refaktoreras

> "Comments are a failure. They are used to compensate for our failure to
> express ourselves in code." — Robert C. Martin

---

## Definition of Done

En uppgift är **KLAR** först när:

- [ ] Implementationen är korrekt (alla tester gröna)
- [ ] Designen är förståelig och namnen är tydliga
- [ ] Den berörda koden är renare än innan
- [ ] Relevanta tester existerar och passerar
- [ ] Ingen uppenbar duplicering eller död kod finns i ändringsområdet

---

## Granska O-commitade Ändringar

När användaren ber om en granskning av ändringar som inte pushats ännu:

### Steg 1: Hitta ändrade filer

Kör git-kommandon för att identifiera vilka filer som ändrats:

```bash
# Alla ändrade filer (staged + unstaged)
git diff --name-only

# Endast staged filer
git diff --cached --name-only

# Endast unstaged filer
git diff --name-only

# Filer i unpushed commits (jämfört med upstream)
git log --oneline origin/main..HEAD --name-only
# (byt main mot aktuell branch)

# Kombinera alla: staged + unstaged + unpushed
(git diff --cached --name-only; git diff --name-only; git log --oneline origin/$(git branch --show-current)..HEAD --name-only 2>/dev/null) | sort -u
```

### Steg 2: Analysera ändringarna

Använd följande verktyg för att granska:

```bash
# Visa ändringsstatistik
git diff --stat

# Visa faktiska ändringar
git diff [staged|unstaged]

# För specifik fil
git diff path/to/file
```

### Steg 3: Applicera Clean Code-principer

Granska varje ändrad fil mot Clean Code-reglerna:

1. **Namngivning**: Har nya/ändrade symboler intention-avslöjande namn?
2. **Storlek**: Är nya funktioner små (under 20 rader)?
3. **Abstraktion**: Blandar koden nivåer?
4. **Sidoeffekter**: Är de explicita i namnet?
5. **Duplicering**: Finns det upprepad logik?
6. **Test**: Finns tester för nya funktioner?

### Steg 4: Sammanfatta och föreslå

Presentera en strukturerad granskning:

```
## Granskning av O-commitade Ändringar

### Ändrade filer
- src/auth/login.ts (staged)
- src/api/users.ts (unstaged)

### Namngivningsproblem
- `handle()` → `validateCredentials()`

### Strukturella problem
- `src/api/users.ts:45` - funktion för lång (85 rader)

### Föreslagna förbättringar
1. Extrahera valideringslogik till `validateUserInput()`
2. Byt namn på `handle` → `validateCredentials`
```

### Arbetsflöde: Före Push

1. Kör `git diff --name-only` för att se alla ändringar
2. Gå igenom varje fil mot Clean Code-reglerna
3. Fixa uppenbara problem direkt
4. Kör `git diff` för att verifiera slutresultatet
5. Commit och push när allt ser rent ut
