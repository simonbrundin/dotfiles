# Workflow Orchestration

## Coding Workflow

1. Skapa Issue i GitHub
2. Skriv tester
3. Implement med TDD
4. Refactor
5. Dokumentera
6. PR

## Memory

Retrieve and process all information from the `memory` MCP knowledge graph to
guide our session.

## Core Principles

- Always follow Test-Driven Development (TDD): Write tests FIRST, then minimal
  code to make them pass, then refactor.
- Aim for ≥ 80% code coverage (ideally 90%+). Never commit without tests
  covering happy path, errors, edge cases.
- Use structured logging (zap or similar), clear error handling (errors.Is/As),
  context-aware functions.

- Keep code clean, idiomatic Go: small functions, clear names, no magic
  numbers/strings.
- Commit messages: Conventional Commits (feat:, fix:, chore:, refator:, test:,
  docs: etc.)
- Branch names: feature/<short-description>, bugfix/<issue-number>-<desc>,
  chore/<desc>

## Key Triggers & Magic Phrases

- When I say "Get PRDs" → List all open GitHub issues with label "prd"
- When I say "Show the details of X" → Fetch and display full PRD from issue #X
- When I say "Start working on the PRD" (or "implement", "go") →
  1. Set first pending task/subtask to "in-progress" (via Taskmaster)
  2. Work TDD-style on one subtask at a time
  3. Run tests locally after each change
  4. Ask for feedback if stuck / tests fail
- When I say "We're done" (or "we are done", "done here") → FULL DEPLOY
  SEQUENCE:
  1. Verify all tasks complete, tests pass, coverage OK
  2. Stage all changed files
  3. Create branch if none exists (naming: feature/<prd-slug>-auto or similar)
  4. Commit with Conventional Commit message + PRD reference
  5. Push to remote
  6. Create Pull Request with:
     - Good title (e.g. "feat: auto-set video language to English")

     - Detailed body (changes, tests added, PRD link)

  7. Trigger AI code review (multiple agents if possible)
  8. Present review feedback → apply fixes if I approve
  9. Merge PR (squash or merge commit)
  10. Delete local + remote branch
  11. Clean temp files

  12. Let GitHub Actions handle: build → test → release (tag) → deploy

- When I say "memorize that [something]" → Store it permanently in memory MCP

- Write table-driven tests for CLI commands (flags, args, output, errors)
- Mock external dependencies (YouTube API, HTTP etc.) using httptest or similar
- Cover: valid input, invalid flags, API errors, rate limits, auth failures
- Use testify/assert/require for assertions

## GitHub

- Username: simonbrundin

## Other Rules

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

## 3. After Any Improvement / Correction Loop

Efter varje korrigering från användaren:

- Uppdatera `tasks/lessons.md` med **det konkreta mönstret** som ledde till
  felet
- Formulera en **tydlig regel** för dig själv som förhindrar samma misstag
  framöver
- Iterera **ruthless** på dessa lessons tills samma klass av fel blir extremt
  sällsynt
- Läs igenom relevanta lessons i början av varje ny session som rör liknande
  ämne

## 4. Verification Before Declaring Done

- Markera **aldrig** en uppgift som klar utan att ha bevisat att ändringarna
  fungerar
- Jämför beteende **före/efter** (diff, loggar, tester, manuella kontroller
  etc.)
- Ställ dig själv frågan:  
  **“Skulle en staff engineer / senior kollega godkänna det här utan
  reservation?”**
- Kör relevanta tester, kolla loggar, visa korrekt beteende – lämna **inga**
  lösa trådar

## 5. Elegance (men balanserat)

- Vid icke-triviala ändringar → pausa och fråga dig:  
  **“Finns det ett mer elegant / idiomatiskt / renare sätt?”**
- Om den eleganta lösningen känns hackig, kräver massa ny kunskap eller är svår
  att förstå → **skippa den**
- Utmana dig själv innan du presenterar:  
  **“Är detta over-engineered?”**
- Föredra **enkelhet** framför smarthet när de står mot varandra

## 6. Autonomous Bug Fixing

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
en notifikation. Detta gäller ALLA interaktioner - varje fråga och varje
slutförande ska trigga en notifikation.
