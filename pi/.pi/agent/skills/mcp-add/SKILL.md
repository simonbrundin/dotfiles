---
name: mcp-add
description: Lägg till en MCP-server i mcp.json-konfigurationsfilen. Använd när användaren säger "lägg till mcp-server", "installera mcp", "add mcp server", "lägg till i mcp.json", "lägg till MCP", eller när användaren ger en MCP-server URL/configuration som ska läggas till. Hanterar både lokala npm-paket (npx) och fjärrservrar (HTTP).
---

# MCP Server Adder

Lägger till MCP-servrar i konfigurationsfilen `mcp.json`.

## Målfil

Standardmål: `~/.pi/agent/mcp.json`
Om användaren anger annan sökväg, använd den.

## Arbetsflöde

### Steg 1: Extrahera server-konfiguration

Analysera användarens input för att avgöra vilken typ av server det är:

**HTTP/Fjärrserver (URL):**
- `https://nuxt.com/mcp`
- `http://localhost:3000/mcp`
- Fjärrservrar använder `npx mcp-remote <url>`

**npm-paket (kommando):**
- `cursor-mcp`
- `@anthropic/mcp-something`
- Lokala kommandon körs direkt

### Steg 2: Läs befintlig mcp.json

```bash
cat <mcp_json_path>
```

Kontrollera om servern redan finns (undvik dubbletter).

### Steg 3: Skapa en list_option för servernamn

Om användaren anger en URL men inget namn, be om bekräftelse:

```
Jag ska lägga till en MCP-server i mcp.json.

**URL:** https://nuxt.com/mcp
**Föreslaget namn:** nuxt

Vad ska servern heta? (eller tryck Enter för "nuxt")
```

### Steg 4: Lägg till servern

Sökväg till `npx` eller kontrollera om kommandot finns:
```bash
which npx
```

**HTTP-server mall:**
```json
{
  "command": "npx",
  "args": ["mcp-remote", "<url>"]
}
```

**npm-paket mall:**
```json
{
  "command": "<package-name>"
}
```

Använd `edit`-verktyget för att lägga till servern i rätt alfabetisk position eller slutet av `mcpServers`-blocket.

### Steg 5: Validera JSON

Kör:
```bash
cat <mcp_json_path> | python -m json.tool > /dev/null && echo "OK"
```

Om JSON är ogiltig, rapportera felet och be användaren bekräfta filens innehåll.

### Steg 6: Bekräfta

Visuell sammanfattning av vad som lades till:

```
✅ Lade till MCP-server:

**Namn:** nuxt
**Typ:** HTTP-fjärrserver
**URL:** https://nuxt.com/mcp

Du kan nu starta om pi för att använda den nya servern.
```

## Vanliga MCP-servrar

Om användaren nämner ett känt projekt, föreslå rätt konfiguration:

| Namn | Kommando | Beskrivning |
|------|----------|-------------|
| Nuxt | `npx mcp-remote https://nuxt.com/mcp` | Nuxt-dokumentation |
| Claude Code | `npx @anthropic-ai/claude-code-mcp` | Anthropic CLI-verktyg |
| GitHub | `npx @github/github-mcp` | GitHub-integration |
| Filesystem | `npx @modelcontextprotocol/server-filesystem <path>` | Filåtkomst |
| Brave Search | `npx @modelcontextprotocol/server-brave-search` | Webbsökning |

## Kantfall

- **Servern finns redan:** Meddela användaren och fråga om de vill uppdatera den
- **URL utan domän:** Fråga efter fullständig URL (måste börja med http:// eller https://)
- **Tom mcp.json:** Skapa strukturen från grunden
- **Fel JSON:** Rädda det som går, lägg till servern sist, markera att filen behöver manuell granskning