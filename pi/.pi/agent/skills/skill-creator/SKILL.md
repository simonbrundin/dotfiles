---
name: skill-creator
description:
  Skapa nya skills, modifiera och förbättra befintliga skills, och mäta
  skill-prestanda. Använd när användaren vill skapa en skill från grunden,
  redigera eller optimera en befintlig skill, köra utvärderingar för att testa
  en skill, jämföra skill-prestanda med variansanalys, eller optimera en skills
  beskrivning för bättre utlösarnoggrannhet.
---

# Skill Creator

En skill för att skapa nya skills och iterativt förbättra dem.

På en hög nivå går processen för att skapa en skill ut så här:

- Bestäm vad du vill att skillen ska göra och ungefär hur den ska göra det
- Skriv ett utkast av skillen
- Skapa några test-prompts och kör modellen med åtkomst till skillen på dem
- Hjälp användaren utvärdera resultaten både kvalitativt och kvantitativt
  - Medan körningarna sker i bakgrunden, skriv några kvantitativa utvärderingar
    om det inte finns några (om det finns några kan du antingen använda dem som
    de är eller modifiera dem om du känner att något behöver ändras). Förklara
    sedan dem för användaren (eller om de redan fanns, förklara de som redan
    finns)
  - Använd `eval-viewer/generate_review.py`-skriptet för att visa användaren
    resultaten och låt dem också titta på de kvantitativa måtten
- Skriv om skillen baserat på feedback från användarens utvärdering av
  resultaten (och även om det finns uppenbara brister som framgår av de
  kvantitativa riktmärkena)
- Upprepa tills du är nöjd
- Expandera testuppsättningen och försök igen i större skala

Din uppgift när du använder denna skill är att lista ut var användaren befinner
sig i denna process och sedan hoppa in och hjälpa dem progressera genom dessa
steg. Så till exempel, kanske säger de "Jag vill göra en skill för X". Du kan
hjälpa till att begränsa vad de menar, skriva ett utkast, skriva testfallen,
lista ut hur de vill utvärdera, köra alla prompts och upprepa.

Å andra sidan, kanske har de redan ett utkast av skillen. I detta fall kan du gå
direkt till utvärderings/iterationsdelen av loopen.

Självklart bör du alltid vara flexibel och om användaren säger "Jag behöver inte
köra massor av utvärderingar, bara hänga med mig", kan du göra det istället.

Sedan, efter att skillen är klar (men återigen, ordningen är flexibel), kan du
också köra beskrivningsoptimeraren, som vi har ett separat skript för, för att
optimera utlösningen av skillen.

Låter bra? Låter bra.

## Kommunicera med användaren

Skill-kreatören kommer sannolikt att användas av människor med vitt skilda
kunskaper om kodterminologi. Om du inte har hört (och hur skulle du kunna, det
är bara väldigt nyligen som det började), så finns det en trend nu där kraften i
AI-modeller inspirerar rörmokare att öppna sina terminaler, föräldrar och
morföräldrar att googla "hur man installerar npm". Å andra sidan är majoriteten
av användarna förmodligen ganska datorkunniga.

Så var vänlig och observera sammanhangskoppar för att förstå hur du ska
formulera din kommunikation! I standardfallet, bara för att ge dig en
uppfattning:

- "utvärdering" och "riktmärke" är gränsfall, men OK
- för "JSON" och "påstående" vill du se allvarliga ledtrådar från användaren att
  de vet vad dessa saker är innan du använder dem utan att förklara dem

Det är OK att kort förklara termer om du är osäker, och känn dig fri att
förtydliga termer med en kort definition om du är osäker på om användaren kommer
att förstå det.

---

## Skapa en skill

### Fånga avsikt

Börja med att förstå användarens avsikt. Den nuvarande konversationen kanske
redan innehåller ett arbetsflöde som användaren vill fånga (t.ex. de säger "gör
detta till en skill"). Om så är fallet, extrahera svar från
konversationshistoriken först — verktygen som använts, sekvensen av steg,
korrigeringar användaren gjort, input/output-format som observerats. Användaren
kan behöva fylla i luckorna, och bör bekräfta innan du går vidare till nästa
steg.

1. Vad ska denna skill göra det möjligt för modellen att göra?
2. När ska denna skill utlösas? (vilka användarfraser/sammanhang)
3. Vilket är det förväntade output-formatet?
4. Ska vi sätta upp testfall för att verifiera att skillen fungerar? Skills med
   objektivt verifierbara outputs (filtransformeringar, dataextraktion,
   kodgenerering, fixa arbetsflödessteg) har nytta av testfall. Skills med
   subjektiva outputs (skrivstil, konst) behöver ofta inte dem. Föreslå lämplig
   standard baserat på skill-typen, men låt användaren bestämma.

### Intervjua och forska

Ställ proaktivt frågor om kantfall, input/output-format, exempelfiler,
framgångskriterier och beroenden. Vänta med att skriva test-prompts tills du har
det här delen klar.

Kontrollera tillgängliga MCP:er - om det är användbart för forskning (söka
dokument, hitta liknande skills, slå upp bästa praxis), gör forskning parallellt
via subagenter om tillgängligt, annars inline. Kom förberedd med sammanhang för
att minska bördan på användaren.

### Skriv SKILL.md

Baserat på användarintervjun, fyll i dessa komponenter:

- **name**: Skill-identifierare
- **description**: När ska den utlösas, vad den gör. Detta är den primära
  utlösmekanismen - inkludera både vad skillen gör OCH specifika sammanhang för
  när den ska användas. All "när ska den användas"-information goes here, not in
  the body. OBS: för närvarande har modeller en tendens att "under-utlösa"
  skills -- att inte använda dem när de skulle vara användbara. För att bekämpa
  detta, gör gärna skill-beskrivningarna lite "pushiga". Så istället för "How to
  build a simple fast dashboard to display internal Anthropic data.", skulle du
  kunna skriva "How to build a simple fast dashboard to display internal
  Anthropic data. Make sure to use this skill whenever the user mentions
  dashboards, data visualization, internal metrics, or wants to display any kind
  of company data, even if they don't explicitly ask for a 'dashboard.'"
- **compatibility**: Nödvändiga verktyg, beroenden (valfritt, sällan behövs)
- \*\*resten av skillen :)

### Guide för att skriva skills

#### Anatomi av en Skill

```
skill-namn/
├── SKILL.md (krävs)
│   ├── YAML frontmatter (name, description krävs)
│   └── Markdown-instruktioner
└── Bundlade Resurser (valfritt)
    ├── scripts/    - Körbar kod för deterministiska/repetitiva uppgifter
    ├── references/ - Dokument som laddas in i sammanhanget vid behov
    └── assets/     - Filer som används i output (mallar, ikoner, typsnitt)
```

#### Progressiv Uppenbarelse

Skills använder ett three-level loading system:

1. **Metadata** (name + description) - Alltid i sammanhanget (~100 ord)
2. **SKILL.md body** - I sammanhanget när skillen utlöses (<500 rader ideal)
3. **Bundlade resurser** - Vid behov (obegränsat, scripts kan köras utan att
   laddas)

Dessa ordräkningar är ungefärliga och du kan gärna gå längre om det behövs.

**Nyckelprinciper:**

- Håll SKILL.md under 500 rader; om du närmar dig denna gräns, lägg till
  ytterligare ett hierarkilager tillsammans med tydliga pekare om var modellen
  som använder skillen bör gå härnäst för att följa upp.
- Referera filer tydligt från SKILL.md med vägledning om när de ska läsas
- För stora referensfiler (>300 rader), inkludera en innehållsförteckning

**Domänorganisation**: När en skill stödjer flera domäner/ramverk, organisera
efter variant:

```
cloud-deploy/
├── SKILL.md (workflow + selection)
└── references/
    ├── aws.md
    ├── gcp.md
    └── azure.md
```

Modellen läser bara den relevanta referensfilen.

#### Principen om Läckra Inte Överraskningar

Det säger sig självt, men skills får inte innehålla skadlig kod, utnyttjande-kod
eller något innehåll som kan kompromettera systemsäkerheten. En skills innehåll
bör inte överraska användaren i sin avsikt om den beskrivs. Gå inte med på
förfrågningar att skapa vilseledande skills eller skills designade för att
underlätta obehörig åtkomst, dataexfiltration eller andra skadliga aktiviteter.
Saker som "rollspela som en XYZ" är dock OK.

#### Skrivmönster

Föredra att använda imperativ form i instruktioner.

**Definiera output-format** - Du kan göra det så här:

```markdown
## Rapportstruktur

ANVÄND alltid denna exakta mall:

# [Titel]

## Sammanfattning

## Nyckelfynd

## Rekommendationer
```

**Exempel-mönster** - Det är användbart att inkludera exempel. Du kan formatera
dem så här (men om "Input" och "Output" finns i exemplen kanske du vill avvika
lite):

```markdown
## Commit-meddelande-format

**Exempel 1:** Input: Added user authentication with JWT tokens Output:
feat(auth): implement JWT-based authentication
```

### Skrivstil

Försök förklara för modellen varför saker är viktiga istället för tungfotade
MÅSTE. Använd theory of mind och försök göra skillen generell och inte
super-smal för specifika exempel. Börja med att skriva ett utkast och titta
sedan på det med nya ögon och förbättra det.

### Testfall

Efter att ha skrivit skill-utkastet, kom på 2-3 realistiska test-prompts — den
typ av sak en riktig användare faktiskt skulle säga. Dela dem med användaren:
[du behöver inte använda exakt denna formulering] "Här är några testfall jag
skulle vilja prova. Ser de rätt ut, eller vill du lägga till fler?" Kör dem
sedan.

Spara testfall till `evals/evals.json`. Skriv inte påståenden ännu — bara
promtarna. Du kommer att skriva påståenden i nästa steg medan körningarna pågår.

```json
{
  "skill_name": "example-skill",
  "evals": [
    {
      "id": 1,
      "prompt": "Användarens uppgifts-prompt",
      "expected_output": "Beskrivning av förväntat resultat",
      "files": []
    }
  ]
}
```

Se `references/schemas.md` för det fullständiga schemat (inklusive
`assertions`-fältet, som du lägger till senare).

## Köra och utvärdera testfall

Detta avsnitt är en kontinuerlig sekvens — stanna inte halvvägs igenom. Använd
INTE `/skill-test` eller någon annan testningsskill.

Lägg resultat i `<skill-namn>-workspace/` som en syskonmapp till
skill-katalogen. Inom arbetsytan, organisera resultat efter iteration
(`iteration-1/`, `iteration-2/`, etc.) och inom den, varje testfall får en
katalog (`eval-0/`, `eval-1/`, etc.). Skapa inte allt detta i förväg — skapa
bara kataloger allteftersom.

### Steg 1: Starta alla körningar (med-skill OCH baseline) i samma omgång

För varje testfall, starta två subagenter i samma omgång — en med skillen, en
utan. Detta är viktigt: starta inte med-skill-körningarna först och sedan kom
tillbaka för baselines senare. Starta allt på en gång så att allt slutförs
ungefär samtidigt.

**Med-skill-körning:**

```
Execute this task:
- Skill path: <path-to-skill>
- Task: <eval prompt>
- Input files: <eval files if any, or "none">
- Save outputs to: <workspace>/iteration-<N>/eval-<ID>/with_skill/outputs/
- Outputs to save: <what the user cares about — e.g., "the .docx file", "the final CSV">
```

**Baseline-körning** (samma prompt, men baselinen beror på sammanhang):

- **Skapar en ny skill**: ingen skill alls. Samma prompt, ingen skill-sökväg,
  spara till `without_skill/outputs/`.
- **Förbättrar en befintlig skill**: den gamla versionen. Innan du redigerar, ta
  en ögonblicksbild av skillen
  (`cp -r <skill-path> <workspace>/skill-snapshot/`), peka sedan
  baseline-subagenten på ögonblicksbilden. Spara till `old_skill/outputs/`.

Skriv en `eval_metadata.json` för varje testfall (påståenden kan vara tomma för
nu). Ge varje eval ett beskrivande namn baserat på vad det testar — inte bara
"eval-0". Använd detta namn även för katalogen. Om denna iteration använder nya
eller modifierade eval-prompts, skapa dessa filer för varje ny eval-katalog —
anta inte att de överförs från tidigare iterationer.

```json
{
  "eval_id": 0,
  "eval_name": "beskrivande-namn-här",
  "prompt": "Användarens uppgifts-prompt",
  "assertions": []
}
```

### Steg 2: Medan körningar pågår, skriv påståenden

Stå inte bara och vänta på att körningarna ska bli klara — du kan använda denna
tid produktivt. Skriv kvantitativa påståenden för varje testfall och förklara
dem för användaren. Om påståenden redan finns i `evals/evals.json`, granska dem
och förklara vad de kontrollerar.

Bra påståenden är objektivt verifierbara och har beskrivande namn — de bör läsas
tydligt i benchmark-visaren så att någon som kastar en snabb blick på resultaten
omedelbart förstår vad varje kontroll gör. Subjektiva skills (skrivstil,
designkvalitet) utvärderas bättre kvalitativt — tvinga inte påståenden på saker
som behöver mänskligt omdöme.

Uppdatera `eval_metadata.json`-filerna och `evals/evals.json` med påståendena
när de är skrivna. Förklara också för användaren vad de kommer att se i visaren
— både de kvalitativa outputen och det kvantitativa riktmärket.

### Steg 3: När körningar blir klara, fånga tidsdata

När varje subagent-uppgift slutförs, får du en notifiering som innehåller
`total_tokens` och `duration_ms`. Spara denna data omedelbart till `timing.json`
i körkatalogen:

```json
{
  "total_tokens": 84852,
  "duration_ms": 23332,
  "total_duration_seconds": 23.3
}
```

Detta är den enda möjligheten att fånga dessa data — de kommer genom
uppgiftsnotifieringen och sparas inte någon annanstans. Behandla varje
notifiering när den kommer istället för att försöka batcha dem.

### Steg 4: Betygsätt, aggregera och starta visaren

När alla körningar är klara:

1. **Betygsätt varje körning** — starta en betygsättnings-subagent (eller
   betygsätt inline) som läser `agents/grader.md` och utvärderar varje påstående
   mot outputen. Spara resultaten till `grading.json` i varje körkatalog.
   Expectations-arrayen i grading.json måste använda fälten `text`, `passed` och
   `evidence` (inte `name`/`met`/`details` eller andra varianter) — visaren är
   beroende av dessa exakta fältnamn. För påståenden som kan kontrolleras
   programmatiskt, skriv och kör ett skript snarare än att titta på det — skript
   är snabbare, mer tillförlitliga och kan återanvändas över iterationer.

2. **Aggregera till benchmark** — kör aggregeringsskriptet från
   skill-creator-katalogen:

   ```bash
   python -m scripts.aggregate_benchmark <workspace>/iteration-N --skill-name <name>
   ```

   Detta producerar `benchmark.json` och `benchmark.md` med pass_rate, time och
   tokens för varje konfiguration, med medelvärde ± standardavvikelse och delta.
   Om du genererar benchmark.json manuellt, se `references/schemas.md` för det
   exakta schemat som visaren förväntar sig. Lägg varje med-skill-version före
   sin baseline-motsvarighet.

3. **Gör en analytiker-pass** — läs benchmark-datan och lyft fram mönster som
   aggregerade statistik kan dölja. Se `agents/analyzer.md` (avsnittet
   "Analysera Benchmark-resultat") för vad du ska let efter — saker som
   påståenden som alltid passerar oavsett skill (icke-diskriminerande),
   hög-varians evals (möjligtvis ostabila), och tid/token-avvägningar.

4. **Starta visaren** med både kvalitativa output och kvantitativ data:

   ```bash
   nohup python <skill-creator-path>/eval-viewer/generate_review.py \
     <workspace>/iteration-N \
     --skill-name "min-skill" \
     --benchmark <workspace>/iteration-N/benchmark.json \
     > /dev/null 2>&1 &
   VIEWER_PID=$!
   ```

   För iteration 2+, skicka också
   `--previous-workspace <workspace>/iteration-<N-1>`.

   **Cowork / headless miljöer:** Om `webbrowser.open()` inte är tillgänglig
   eller miljön saknar skärm, använd `--static <output_path>` för att skriva en
   fristående HTML-fil istället för att starta en server. Feedback kommer att
   laddas ner som en `feedback.json`-fil när användaren klickar på "Submit All
   Reviews". Efter nedladdning, kopiera `feedback.json` till arbetskatalogen för
   nästa iteration att plocka upp.

   OBS: använd generate_review.py för att skapa visaren; det finns inget behov
   av att skriva egen HTML.

5. **Berätta för användaren** något i stil med: "Jag har öppnat resultaten i din
   webbläsare. Det finns två flikar — 'Outputs' låter dig klicka genom varje
   testfall och lämna feedback, 'Benchmark' visar den kvantitativa jämförelsen.
   När du är klar, kom tillbaka hit och berätta för mig."

### Vad användaren ser i visaren

"Outputs"-fliken visar ett testfall i taget:

- **Prompt**: uppgiften som gavs
- **Output**: filerna som skillen producerade, renderade inline där det är
  möjligt
- **Previous Output** (iteration 2+): ihopfälld sektion som visar förra
  iterationens output
- **Formal Grades** (om betygsättning kördes): ihopfälld sektion som visar
  påstående-pass/fail
- **Feedback**: en textruta som sparar automatiskt när de skriver
- **Previous Feedback** (iteration 2+): deras kommentarer från förra gången,
  visas nedanför textrutan

"Benchmark"-fliken visar statistiksammanfattningen: pass rates, timing och
token-användning för varje konfiguration, med per-eval-uppdelningar och
analytikerobservationer.

Navigation sker via prev/next-knappar eller piltangenterna. När de är klara
klickar de på "Submit All Reviews" vilket sparar all feedback till
`feedback.json`.

### Steg 5: Läs feedbacken

När användaren berättar att de är klara, läs `feedback.json`:

```json
{
  "reviews": [
    {
      "run_id": "eval-0-with_skill",
      "feedback": "grafen saknar axeletiketter",
      "timestamp": "..."
    },
    { "run_id": "eval-1-with_skill", "feedback": "", "timestamp": "..." },
    {
      "run_id": "eval-2-with_skill",
      "feedback": "perfekt, älskar detta",
      "timestamp": "..."
    }
  ],
  "status": "complete"
}
```

Tom feedback betyder att användaren tyckte det var bra. Fokusera dina
förbättringar på de testfall där användaren hade specifika klagomål.

Döda visar-servern när du är klar med den:

```bash
kill $VIEWER_PID 2>/dev/null
```

---

## Förbättra skillen

Detta är hjärtat i loopen. Du har kört testfallen, användaren har granskat
resultaten, och nu måste du göra skillen bättre baserat på deras feedback.

### Hur man tänker på förbättringar

1. **Generalisera från feedbacken.** Den stora bilden här är att vi försöker
   skapa skills som kan användas en miljon gånger (kanske bokstavligen, kanske
   ännu mer vem vet) över många olika prompts. Här arbetar du och användaren och
   itererar på bara några få exempel om och om igen eftersom det hjälper att gå
   snabbare. Användaren känner dessa exempel utan och in och det är snabbt för
   dem att bedöma nya outputs. Men om skillen du och användaren kodar endast
   fungerar för dessa exempel, är den värdelös. snarare än att lägga in
   finjusterade överanpassade ändringar, eller förtryckande begränsande MÅSTE,
   om det finns ett envis problem, kan du försöka bredda dig och använda olika
   metaforer, eller rekommendera olika arbetsmönster. Det är relativt billigt
   att prova och kanske landar du på något fantastiskt.

2. **Håll prompten smal.** Ta bort saker som inte drar sitt laster. Se till att
   läsa transkripten, inte bara de slutliga outputen — om det ser ut som att
   skillen får modellen att slösa bort massa tid på att göra saker som är
   improduktiva, kan du försöka bli av med de delar av skillen som får den att
   göra det och se vad som händer.

3. **Förklara varför.** Försök hårt förklara **varför** bakom allt du ber
   modellen göra. Dagens AI:er är _smarta_. De har god theory of mind och när de
   får en bra inramning kan de gå beyond rote-instruktioner och verkligen få
   saker att hända. Även om feedbacken från användaren är kort eller frustrerad,
   försök faktiskt förstå uppgiften och varför användaren skrev vad de skrev,
   och vad de faktiskt skrev, och överför sedan denna förståelse till
   instruktionerna. Om du märker att du skriver ALLTID eller ALDRIG med
   versaler, eller använder super-stela strukturer, är det ett gult
   varningstecken — om möjligt, omformulera och förklara resonemanget så att
   modellen förstår varför det du ber om är viktigt. Det är en mer humain,
   kraftfull och effektiv approach.

4. **Leta efter upprepat arbete över testfall.** Läs transkripten från
   testkörningarna och observera om subagenterna alla oberoende skrev liknande
   hjälpskript eller tog samma flerstegs approach till något. Om alla 3
   testfallen resulterade i att subagenten skrev ett `create_docx.py` eller ett
   `build_chart.py`, är det en stark signal att skillen borde bunta det
   skriptet. Skriv det en gång, lägg det i `scripts/`, och berätta för skillen
   att använda det. Detta sparar varje framtida anrop från att uppfinna hjulet
   igen.

Den här uppgiften är ganska viktig (vi försöker skapa miljarder i ekonomiskt
värde här!) och din tänkande-tid är inte flaskhalsen; ta din tid och fundera
ordentligt. Jag föreslår att du skriver ett utkast till revision och sedan
tittar på det med nya ögon och gör förbättringar. Gör verkligen ditt bästa för
att komma in i användarens huvud och förstå vad de vill och behöver.

### Iterationsloopen

Efter att ha förbättrat skillen:

1. Applicera dina förbättringar på skillen
2. Kör om alla testfall till en ny `iteration-<N+1>/`-katalog, inklusive
   baseline-körningar. Om du skapar en ny skill, är baselinen alltid
   `without_skill` (ingen skill) — den förblir densamma över iterationer. Om du
   förbättrar en befintlig skill, använd ditt omdöme om vad som gör sense som
   baseline: originalversionen användaren kom med, eller föregående iteration.
3. Starta granskaren med `--previous-workspace` som pekar på föregående
   iteration
4. Vänta på att användaren ska granska och berätta att de är klara
5. Läs den nya feedbacken, förbättra igen, upprepa

Fortsätt tills:

- Användaren säger att de är nöjda
- Feedbacken är alltom tom (allt ser bra ut)
- Du gör inte meningsfull framsteg

---

## Avancerat: Blind jämförelse

För situationer där du vill ha en mer rigorös jämförelse mellan två versioner av
en skill (t.ex. användaren frågar "är den nya versionen faktiskt bättre?"),
finns det ett blind jämförelsesystem. Läs `agents/comparator.md` och
`agents/analyzer.md` för detaljerna. Grundidén är: ge två outputs till en
oberoende agent utan att berätta vilken som är vilken, och låt den bedöma
kvalitet. Analysera sedan varför vinnaren vann.

Detta är valfritt, kräver subagenter, och de flesta användare behöver det inte.
Den mänskliga granskningsloopen är vanligtvis tillräcklig.

---

## Beskrivningsoptimering

Description-fältet i SKILL.md frontmatter är den primära mekanismen som avgör om
modellen anropar en skill. Efter att ha skapat eller förbättrat en skill,
erbjuda att optimera beskrivningen för bättre utlösningsnoggrannhet.

### Steg 1: Generera trigger-eval-frågor

Skapa 20 eval-frågor — en mix av should-trigger och should-not-trigger. Spara
som JSON:

```json
[
  { "query": "användarens prompt", "should_trigger": true },
  { "query": "en annan prompt", "should_trigger": false }
]
```

Frågorna måste vara realistiska och något en användare faktiskt skulle skriva.
Inte abstrakta förfrågningar, utan förfrågningar som är konkreta och specifika
och har en bra mängd detaljer. Till exempel filvägar, personlig kontext om
användarens jobb eller situation, kolumnnamn och värden, företagsnamn, URL:er.
Lite bakgrundshistoria. Vissa kan vara i lowercase eller innehålla förkortningar
eller stavfel eller vardagligt språk. Använd en mix av olika längder, och
fokusera på kantfall snarare än att göra dem tydliga (användaren kommer att få
chansen att godkänna dem).

Dåligt: `"Formatera denna data"`, `"Extrahera text från PDF"`,
`"Skapa ett diagram"`

Bra:
`"okej så min chef skickade precis denna xlsx-fil (den är i mina nedladdningar, heter något som 'Q4 försäljning final FINAL v2.xlsx') och hon vill att jag lägger till en kolumn som visar vinstmarginalen i procent. Intäkterna är i kolumn C och kostnaderna är i kolumn D tror jag"`

För **should-trigger-frågorna** (8-10), tänk på täckning. Du vill ha olika
formuleringar av samma avsikt — some formal, some casual. Inkludera fall där
användaren inte explicit namnger skillen eller filtypen men tydligt behöver den.
Kasta in några ovanliga användningsfall och fall där denna skill konkurrerar med
en annan men bör vinna.

För **should-not-trigger-frågorna** (8-10), de mest värdefulla är de som
nästan-triggar — frågor som delar nyckelord eller koncept med skillen men
faktiskt behöver något annat. Tänk på intilliggande domäner, tvetydig
formulering där en naiv nyckelordsmatchning skulle trigga men inte borde, och
fall där frågan berör något skillen gör men i ett sammanhang där ett annat
verktyg är mer lämpligt.

Den viktigaste saken att undvika: gör inte should-not-trigger-frågor uppenbart
irrelevanta. "Skriv en fibonacci-funktion" som negativ test för en PDF-skill är
för lätt — det testar inget. De negativa fallen bör vara genuint knepiga.

### Steg 2: Granska med användaren

Presentera eval-uppsättningen för användaren med HTML-mallen:

1. Läs mallen från `assets/eval_review.html`
2. Ersätt placeholders:
   - `__EVAL_DATA_PLACEHOLDER__` → JSON-arrayen av eval-items (inga citattecken
     runt den — det är en JS-variabeltilldelning)
   - `__SKILL_NAME_PLACEHOLDER__` → skillens namn
   - `__SKILL_DESCRIPTION_PLACEHOLDER__` → skillens nuvarande beskrivning
3. Skriv till en temp-fil (t.ex. `/tmp/eval_review_<skill-name>.html`) och öppna
   den: `open /tmp/eval_review_<skill-name>.html`
4. Användaren kan redigera frågor, toggla should-trigger, lägga till/ta bort
   poster, och sedan klicka på "Export Eval Set"
5. Filen laddas ner till `~/Downloads/eval_set.json` — kolla
   Nedladdningar-mappen efter den senaste versionen om det finns flera (t.ex.
   `eval_set (1).json`)

Detta steg spelar roll — dåliga eval-frågor leder till dåliga beskrivningar.

### Steg 3: Kör optimeringsloopen

Berätta för användaren: "Detta kommer att ta lite tid — jag kommer att köra
optimeringsloopen i bakgrunden och kolla på den periodiskt."

Spara eval-uppsättningen till arbetsytan, kör sedan i bakgrunden:

```bash
python -m scripts.run_loop \
  --eval-set <path-to-trigger-eval.json> \
  --skill-path <path-to-skill> \
  --model <model-id-powering-this-session> \
  --max-iterations 5 \
  --verbose
```

Använd modell-ID:t från ditt system-prompt (den som driver den nuvarande
sessionen) så att triggertestet matchar det användaren faktiskt upplever.

Medan den kör, kolla ibland på outputen för att ge användaren uppdateringar om
vilken iteration den är på och vad poängen ser ut.

Detta hanterar hela optimeringsloopen automatiskt. Den delar eval-uppsättningen
i 60% träning och 40% hold-out test, utvärderar den nuvarande beskrivningen (kör
varje fråga 3 gånger för att få en pålitlig trigger-rate), och anropar sedan
modellen för att föreslå förbättringar baserat på vad som misslyckades. Den
omutvärderar varje ny beskrivning på både träning och test, itererar upp till 5
gånger. När den är klar öppnar den en HTML-rapport i webbläsaren som visar
resultaten per iteration och returnerar JSON med `best_description` — vald av
test-poäng snarare än tränings-poäng för att undvika overfitting.

### Hur skill-utlösning fungerar

Att förstå utlösmekanismen hjälper att designa bättre eval-frågor. Skills visas
i modellens `available_skills`-lista med deras namn + beskrivning, och modellen
bestämmer om den ska konsultera en skill baserat på den beskrivningen. Det
viktiga att veta är att modellen bara konsulterar skills för uppgifter den inte
lätt kan hantera på egen hand — enkla, ensidiga frågor som "läsa denna PDF"
kanske inte utlöser en skill även om beskrivningen matchar perfekt, för att
modellen kan hantera dem direkt med grundläggande verktyg. Komplexa, flerstegs
eller specialiserade frågor utlöser tillförlitligt skills när beskrivningen
matchar.

Detta betyder att dina eval-frågor bör vara tillräckligt substansiella för att
modellen faktiskt skulle ha nytta av att konsultera en skill. Enkla frågor som
"läs fil X" är dåliga testfall — de kommer inte att utlösa skills oavsett
beskrivningskvalitet.

### Steg 4: Applicera resultatet

Ta `best_description` från JSON-output och uppdatera skillens SKILL.md
frontmatter. Visa användaren före/efter och rapportera poängen.

---

### Paketera och presentera (bara om `present_files`-verktyget är tillgängligt)

Kontrollera om du har tillgång till `present_files`-verktyget. Om du inte har
det, hoppa över detta steg. Om du har det, paketera skillen och presentera
.skill-filen för användaren:

```bash
python -m scripts.package_skill <path/to/skill-folder>
```

Efter paketering, peka användaren till den resulterande .skill-filens sökväg så
de kan installera den.

---

## Anpassning för pi-miljön

I pi-miljön fungerar huvudarbetsflödet (skapa utkast → testa → granska →
förbättra → upprepa), men eftersom pi är en agent-harnesk finns det några
anpassningar:

**Köra testfall**: Pi har subagenter, så huvudarbetsflödet (starta testfall
parallellt, kör baselines, betygsätt, etc.) fungerar. Du kan använda
`fn_delegate_task` för att köra utvärderingar.

**Granska resultat**: Pi:s miljö kan sakna webbläsare. I så fall, generera en
statisk HTML med `generate_review.py --static <output>` och presentera
resultaten i konversationen eller som en fil användaren kan öppna.

**Benchmarking**: Använd subagenter för parallella körningar och samla in
timing-data. Skapa `benchmark.json` enligt schemat i `references/schemas.md`.

**Iterationsloopen**: Samma som beskrivet — förbättra skillen, kör om
testfallen, be om feedback — upprepa.

**Beskrivningsoptimering**: Detta kräver `claude -p` via subprocess, vilket kan
fungera i pi-miljön. Spara det tills du har fullständigt slutfört skillen och
användaren håller med om att den är i god form.

---

## Referensfiler

Agents/-katalogen innehåller instruktioner för specialiserade subagenter. Läs
dem när du behöver starta den relevanta subagenten.

- `agents/grader.md` — Hur man utvärderar påståenden mot outputs
- `agents/comparator.md` — Hur man gör blind A/B-jämförelse mellan två outputs
- `agents/analyzer.md` — Hur man analyserar varför en version slog en annan

References/-katalogen har ytterligare dokumentation:

- `references/schemas.md` — JSON-strukturer för evals.json, grading.json, etc.

---

Upprepar en gång till kärnloopen här för betoning:

- Lista ut vad skillen handlar om
- Skriv eller redigera skillen
- Kör modellen med åtkomst till skillen på test-prompts
- Med användaren, utvärdera outputs:
  - Skapa benchmark.json och kör `eval-viewer/generate_review.py` för att hjälpa
    användaren granska dem
  - Kör kvantitativa utvärderingar
- Upprepa tills du och användaren är nöjda
- Paketera den slutliga skillen och returnera den till användaren.

Lägg till steg i din att-göra-lista om du har en sådan, för att säkerställa att
du inte glömmer. Lägg specifikt in "Skapa evals JSON och kör
`eval-viewer/generate_review.py` så att människan kan granska testfall" i din
att-göra-lista för att säkerställa att det händer.

Lyckan till!

## Referensfiler

Agents/-katalogen innehåller instruktioner för specialiserade subagenter. Läs
dem när du behöver starta den relevanta subagenten.

- `agents/grader.md` — Hur man utvärderar påståenden mot outputs
- `agents/comparator.md` — Hur man gör blind A/B-jämförelse mellan två outputs
- `agents/analyzer.md` — Hur man analyserar varför en version slog en annan

References/-katalogen har ytterligare dokumentation:

- `references/schemas.md` — JSON-strukturer för evals.json, grading.json, etc.

---

Upprepar en gång till kärnloopen här för betoning:

- Lista ut vad skillen handlar om
- Skriv eller redigera skillen
- Kör modellen med åtkomst till skillen på test-prompts
- Med användaren, utvärdera outputs:
  - Skapa benchmark.json och kör `eval-viewer/generate_review.py` för att hjälpa
    användaren granska dem
  - Kör kvantitativa utvärderingar
- Upprepa tills du och användaren är nöjda
- Paketera den slutliga skillen och returnera den till användaren.

Lägg till steg i din att-göra-lista om du har en sådan, för att säkerställa att
du inte glömmer. Lägg specifikt in "Skapa evals JSON och kör
`eval-viewer/generate_review.py` så att människan kan granska testfall" i din
att-göra-lista för att säkerställa att det händer.

Lyckan till!

