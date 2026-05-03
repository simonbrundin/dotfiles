# Information för agenter

## Hämta projektinformation

Läs in dessa projektspecifika filer från repot du körs ifrån

- `.agent/AGENTS.md`

## GitHub

- Username: simonbrundin

## Regler

- **Svara alltid på svenska** - oavsett om frågan är på engelska eller svenska
- Always use latest docs via Context7 MCP – never rely on outdated knowledge
- Fork-aware: Work ONLY in my fork (update memory if needed: replace vfarcic
  with my username)
- If something is unclear → ask me before proceeding
- Be verbose in explanations when I ask "why" or "explain"

- Offload följande till subagenter:
  - Forskning / insamling av information
  - Utforskning / alternativa tillvägagångssätt
  - Parallella analyser
  - Komplexa beräkningar eller långa resonemang
- **En sak i taget** per subagent → mycket högre chans till fokuserad och
  korrekt exekvering
- Skippa self-reflection i subagenter när det inte tillför värde

---

## Behavioral Guidelines (Andrej Karpathy Style)

**Tradeoff:** Dessa riktlinjer biasar mot försiktighet över hastighet. För
triviala uppgifter, använd eget omdöme.

### 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Innan du implementerar:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes,
simplify.

### 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

### 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it
work") require constant clarification.

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer
rewrites due to overcomplication, and clarifying questions come before
implementation rather than after mistakes.

---

## 5. After Any Improvement / Correction Loop

Efter varje korrigering från användaren:

- Uppdatera `tasks/lessons.md` med **det konkreta mönstret** som ledde till
  felet
- Formulera en **tydlig regel** för dig själv som förhindrar samma misstag
  framöver
- Iterera **ruthless** på dessa lessons tills samma klass av fel blir extremt
  sällsynt
- Läs igenom relevanta lessons i början av varje ny session som rör liknande
  ämne

## 6. Verification Before Declaring Done

- Markera **aldrig** en uppgift som klar utan att ha bevisat att ändringarna
  fungerar
- Jämför beteende **före/efter** (diff, loggar, tester, manuella kontroller
  etc.)
- Ställ dig själv frågan: **"Skulle en staff engineer / senior kollega godkänna
  det här utan reservation?"**
- Kör relevanta tester, kolla loggar, visa korrekt beteende – lämna **inga**
  lösa trådar

## 7. Elegance (men balanserat)

- Vid icke-triviala ändringar → pausa och fråga dig:  
  **“Finns det ett mer elegant / idiomatiskt / renare sätt?”**
- Om den eleganta lösningen känns hackig, kräver massa ny kunskap eller är svår
  att förstå → **skippa den**
- Utmana dig själv innan du presenterar:  
  **“Är detta over-engineered?”**
- Föredra **enkelhet** framför smarthet när de står mot varandra

## 8. Autonomous Bug Fixing

- När du får en buggrapport → **fixa den självständigt** utan att genast be om
  mer hjälp
- Börja alltid med att:
  - Pekar på vilka tester som fallerar
  - Refererar relevanta loggar / felmeddelanden
  - Visar vad du redan förstår om problemet
- Lös problemet – **minimal** handhållning förväntas
- Noll förväntan på att användaren ska ge exakt CI-kontext eller steg-för-steg

## Task Management – Checklista

1. **Planera först**  
   Skriv plan i `tasks/todo.md` med **konkreta, checkbara** punkter

2. **Verifiera planen**  
   Dubbelkolla innan implementation påbörjas

3. **Förklara förändringar**  
   Skriv hög-nivå sammanfattning vid varje större steg / commit-block

4. **Tracka framsteg**  
   Markera klart i todo-filen löpande

5. **Dokumentera resultat**  
   Lägg till review-/avslutningssektion i `tasks/todo.md`

6. **Fånga lärdomar**  
   Uppdatera `tasks/lessons.md` efter varje korrigering / förbättring

## Core Principles

- **Simplicity First**  
  Gör varje ändring så enkel som möjligt. Minsta möjliga kodpåverkan.

- **Senior Laziness**  
  Hitta rotorsaken. Inga temporära fixes. Håll **seniorutvecklingsstandard**.

- **Minimal Impact**  
  Rör bara det som verkligen måste röras. Undvik att introducera nya buggar.

- **Never Ignore Errors**  
  Använd ALDRIG `_` för att ignorera fel vid I/O, CLI-kommandon eller
  API-anrop.  
  Fel ska alltid hanteras och visas till användaren med användarvänliga
  meddelanden.

- **Avoid Variable Shadowing**  
  Använd INTE variabelnamn som skuggar package-namn (t.ex. `errors`, `fmt`,
  `json`).  
  Använd beskrivande namn som `repoErrors`, `fetchErr` etc.

- **Extract Magic Strings**  
  Extrahera magic strings till namngivna konstanter för bättre läsbarhet och
  underhåll.

## Testbarhet

- Gör funktioner testbara: Bryt ut affärslogik från HTTP-handlers
- Använd httptest för att testa HTTP-handlers utan riktiga nätverksanrop
- Testa alltid efter refaktorering — gröna tester = ingen regression

## Notifications

### När du väntar på input

Innan du använder `question`-verktyget eller väntar på användarens svar:

```bash
notify-send -u normal "OpenCode: Question" "OpenCode väntar på dig - kolla terminalen"
```

### När uppgiften är klar

Efter att du har slutfört en uppgift eller är färdig med arbetet:

```bash
notify-send -u low "OpenCode: Complete" "OpenCode är färdig"
```

Detta gäller ALLA interaktioner - varje fråga och varje slutförande ska trigga
en notifikation.
