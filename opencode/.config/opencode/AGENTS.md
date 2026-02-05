# Workflow Orchestration

## 1. Plan Mode (Default för icke-triviala uppgifter)

- Gäller allt som kräver **3+ steg** eller viktiga arkitektur-/designbeslut
- Om något börjar gå snett → **STOPPA omedelbart**, gör om planen – fortsätt
  **inte** bara att köra på
- Använd plan-läget även för **verifieringssteg** – inte bara för själva
  byggandet
- Skriv **detaljerade specs** och verifieringskriterier **i förväg** för att
  minska oklarheter

## 2. Subagent-strategi

- Använd subagenter **generöst** för att hålla huvudkontexten ren och liten
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

## Notifications

När OpenCode väntar på input ELLER är klar med en uppgift:

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

Detta gäller ALLA interaktioner - varje fråga och varje slutförande ska trigga en notifikation.
