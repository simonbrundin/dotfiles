---
name: readme-refresher
description: >
  Uppdaterar README.md med ny information och tar bort gammal irrelevant
  information. Skapar en interaktiv HTML-sida med rad-för-rad diff,
  individuella accept/avvisa-knappar, och sparas DIRECT till filen.

  ANVÄND DENNA SKILL när användaren säger:
  - "uppdatera readme"
  - "uppdatera README med ny info"
  - "färskla upp readme"
  - "uppdatera dokumentationen"
  - "förnya readme"
  - "visa diff för readme"
  - "granska readme ändringar"
---

# README Refresher

Uppdaterar README.md med ny information, tar bort gammalt, och presenterar
ändringarna i en interaktiv HTML-sida. Ändringar sparas direkt till filen.

## Arbetsflöde

### 1. Identifiera och läs README

```bash
# Hitta README i projektet
find . -maxdepth 2 -name "README.md" -type f

# Läs befintligt innehåll
cat README.md
```

### 2. Analysera och planera ändringar

Identifiera:
- Gammal/irrelevant information (föråldrat, trasigt, utdaterat)
- Skrivfel
- Nya avsnitt att lägga till
- Uppdateringar som behövs

### 3. Starta write_server

```bash
cd /home/simon/.pi/agent/skills/readme-refresher
python3 scripts/write_server.py /path/to/README.md &
sleep 2
```

Standard port: **8767**

### 4. Generera HTML-gränssnitt

Skapa `/tmp/readme-interface.html` med denna mall och fyll i CONFIG:

```html
<!DOCTYPE html>
<html lang="sv">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>README Diff - [PROJEKT]</title>
  <style>
    :root {
      --bg-dark: #0f172a; --bg-card: #1e293b; --bg-hover: #334155;
      --text-primary: #f1f5f9; --text-secondary: #94a3b8; --text-muted: #64748b;
      --border: #334155;
      --added-bg: rgba(34, 197, 94, 0.15); --added-border: #22c55e; --added-text: #4ade80;
      --removed-bg: rgba(239, 68, 68, 0.15); --removed-border: #ef4444; --removed-text: #f87171;
      --modified-bg: rgba(234, 179, 8, 0.15); --modified-border: #eab308; --modified-text: #facc15;
      --accent: #3b82f6;
    }
    * { box-sizing: border-box; }
    body { font-family: system-ui, sans-serif; margin: 0; padding: 0; background: var(--bg-dark); color: var(--text-primary); }
    /* [Fullständig CSS - se befintlig mall] */
  </style>
</head>
<body>
  <script>
    const CONFIG = {
      projectName: 'PROJEKTNAMN',
      readmePath: '/path/to/README.md',
      // ORIGINAL innehåll utan ändringar
      originalContent: `# ORIGINAL README...`,
      // SLUTGILTIGT innehåll med ALLA ändringar applicerade
      finalContent: `# FULLSTÄNDIG UPDATED README...`,
      changes: [
        {
          id: 1,
          type: 'added', // 'added' | 'removed' | 'modified'
          linesBefore: [], // Tom för 'added'
          linesAfter: ['rad 1', 'rad 2'],
          explanation: 'Varför denna läggs till',
          status: 'pending'
        },
        // ... fler ändringar
      ]
    };

    let currentFilter = 'all';
    let currentIndex = 0;
    let changes = CONFIG.changes.map(c => ({...c}));

    function init() {
      document.getElementById('project-name').textContent = CONFIG.projectName;
      renderSummary(); renderChanges(); renderPreview(); updateNavigation();
    }
    // [Fullständig JS - se befintlig mall]

    function generateFinalReadme() {
      return CONFIG.finalContent; // Enkelt: returnera fördefinierad slutversion
    }
    // [Resten av JS-funktioner]
  </script>
  <!-- [HTML-struktur - se befintlig mall] -->
  <script>init();</script>
</body>
</html>
```

### 5. Öppna i webbläsare

```bash
open http://localhost:8767
```

## HTML-gränssnittets funktioner

### Individuella kontroller per ändring
- **✅ Acceptera** - Godkänn denna ändring
- **❌ Avvisa** - Förkasta denna ändring  
- **✏️ Redigera** - Skriv egen version i modal

### Live Preview
- Visar slutresultatet i realtid
- Uppdateras när du accepterar/avvisar

### Spara direkt
- **💾 Spara till README.md** - Skriver DIRECT till filen via server
- **📂 Öppna i editor** - Öppnar filen efter sparning

### Filter & Navigation
- Filter: Alla / + Tillagt / - Borttaget / ~ Modifierat
- Piltangenter ◀ ▶ för navigation

## write_server.py

```python
#!/usr/bin/env python3
"""Lokal server som sparar README-uppdateringar direkt till fil."""

import http.server, socketserver, json, sys, os
from urllib.parse import parse_qs

PORT = 8767

class ReadmeHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/' or self.path == '/index.html':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            with open('/tmp/readme-interface.html', 'r') as f:
                self.wfile.write(f.read().encode('utf-8'))

    def do_POST(self):
        if self.path == '/save':
            content_length = int(self.headers['Content-Length'])
            data = json.loads(self.rfile.read(content_length).decode('utf-8'))
            with open(data['path'], 'w') as f:
                f.write(data['content'])
            self.send_json_response({'success': True, 'message': f"Sparat till {data['path']}"})
        elif self.path == '/open':
            content_length = int(self.headers['Content-Length'])
            data = json.loads(self.rfile.read(content_length).decode('utf-8'))
            os.system(f'open "{data["path"]}" 2>/dev/null || xdg-open "{data["path"]}"')
            self.send_json_response({'success': True})

    def send_json_response(self, data):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.wfile.write(json.dumps(data).encode('utf-8'))

    def log_message(self, format, *args):
        try:
            msg = str(args[0]) if args else str(format)
            if 'save' not in msg:
                super().log_message(format, *args)
        except: pass

def main():
    readme_path = os.path.abspath(sys.argv[1]) if len(sys.argv) > 1 else '/tmp/README.md'
    print(f"📝 README Path: {readme_path}")
    print(f"🌐 Öppna: http://localhost:{PORT}")
    
    with socketserver.TCPServer(("", PORT), ReadmeHandler) as httpd:
        httpd.serve_forever()

if __name__ == '__main__':
    main()
```

## Viktiga principer

### CONFIG-struktur (KRITISKT)

1. **`originalContent`**: EXAKT vad som finns nu i README (utan ändringar)
2. **`finalContent`**: EXAKT slutresultatet med ALLA ändringar applicerade
3. **`changes`**: Lista med individuella ändringar

### FinalContent-regler
- Måste matcha exakt det som ska sparas
- Inkludera ALLA ändringar (både accepterade och avvisade)
- Användaren väljer senare vad som ska sparas via accept/avvisa

### Change-regler
- `type`: 'added', 'removed', eller 'modified'
- `linesBefore`: Rader som tas bort/ersätts (tom för 'added')
- `linesAfter`: Nya rader som läggs till/ersätter med (tom för 'removed')
- `explanation`: Kort förklaring för användaren
- `status`: Alltid 'pending' initialt

## Komplett exempel: CONFIG

```javascript
const CONFIG = {
  projectName: 'mitt-projekt',
  readmePath: '/home/simon/repos/mitt-projekt/README.md',
  originalContent: `# Mitt Projekt

## Installation

\`\`\`bash
npm install
\`\`\`

## Usage

Använd projektet så här...
`,
  finalContent: `# Mitt Projekt

> Uppdaterad beskrivning

## Installation

\`\`\`bash
npm install
npm run dev
\`\`\`

## Usage

Använd projektet så här...

## Konfiguration

Läs config.md för detaljer.
`,
  changes: [
    {
      id: 1,
      type: 'added',
      linesBefore: [],
      linesAfter: ['> Uppdaterad beskrivning'],
      explanation: 'La till en beskrivning av projektet',
      status: 'pending'
    },
    {
      id: 2,
      type: 'modified',
      linesBefore: ['\`\`\`bash', 'npm install', '\`\`\`'],
      linesAfter: ['\`\`\`bash', 'npm install', 'npm run dev', '\`\`\`'],
      explanation: 'La till dev-kommandot',
      status: 'pending'
    },
    {
      id: 3,
      type: 'added',
      linesBefore: [],
      linesAfter: ['## Konfiguration', '', 'Läs config.md för detaljer.'],
      explanation: 'Nytt avsnitt om konfiguration',
      status: 'pending'
    }
  ]
};
```

## Felhantering

| Problem | Lösning |
|---------|---------|
| "Server ej ansluten" | Starta om write_server.py |
| Port upptagen | Ändra PORT i write_server.py |
| Fel i finalContent | Verifiera att det matchar önskad output |

## Stoppa servern

```bash
pkill -f write_server.py
```
