---
name: sops-create-secret
description: |
  Skapa en ny krypterad Kubernetes Secret med SOPS och age. Utlösare: "skapa secret", 
  "create secret", "ny kubernetes secret", "sops encrypt secret", "kryptera secret",
  "kubectl create secret", "kubernetes secret", "nytt secret", "skapa krypterad hemlighet".
  Använd denna skill när användaren vill skapa en ny SOPS-krypterad secret för Kubernetes,
  oavsett om de säger "secret", "hemlighet", eller "krypterad fil".
---

# SOPS Create Secret Skill

Skapa en ny krypterad Kubernetes Secret med SOPS och age. Denna skill guidar dig
genom en interaktiv process för att skapa, kryptera och spara secrets på rätt
plats.

Denna skill fungerar med **vilket repo som helst** som använder SOPS, inte bara
infrastructure-repot. Den hittar automatiskt SOPS-konfiguration och age-nycklar.

## Arbetsflöde

### Steg 0: Identifiera repo och SOPS-konfiguration

**Viktigt:** Börja alltid med att identifiera vilket repo användaren arbetar
med.

1. **Fråga om repo** (om det inte redan framgår av kontexten):
   - "Vilket repo vill du spara secretet i?"
   - Om användaren anger ett repo-namn, konvertera till sökväg:
     `/home/simon/repos/<repo-name>`

2. **Leta efter SOPS-konfiguration i repots rot:**

   ```bash
   # Sök efter SOPS config i repots rot
   ls -la /home/simon/repos/<repo>/.sops.yaml
   ls -la /home/simon/repos/<repo>/.sops.conf
   ls -la /home/simon/repos/<repo>/sops.yaml
   ```

3. **Leta efter publika age-nycklar:**

   ```bash
   # Sök i typiska secrets-mappar
   find /home/simon/repos/<repo> -name "*.age.pub" -o -name "sops.age.pub" -o -name "*.pub" 2>/dev/null
   # Sök i components/secrets/ om det finns
   ls /home/simon/repos/<repo>/components/secrets/*.pub 2>/dev/null
   ls /home/simon/repos/<repo>/secrets/*.pub 2>/dev/null
   ```

4. **Om ingen SOPS-config hittas:**
   - Fråga användaren: "Hittade ingen SOPS-konfiguration i detta repo. Vill du:"
     - A) Ange sökväg till en extern SOPS-config
     - B) Använd standard age-nyckeln (infrastructure-repot)
     - C) Skapa en ny SOPS-config i detta repo

**Standard repo:** Om inget anges, anta `/home/simon/repos/infrastructure/`

### Steg 1: Interaktiv input-insamling

**Hemligheten ska användas för:**

- Fråga användaren vad secretet är till för
- Detta hjälper dig föreslå:
  - Lämpligt secret-namn
  - Rätt secret-typ (generic, tls, docker-registry)
  - Vilka nyckel-värde-par som behövs

### Steg 2: Föreslå och bekräfta

**För varje parameter, föreslå och bekräfta:**

1. **Secret-namn** (obligatoriskt)
   - Föreslå ett beskrivande namn baserat på användning
   - Format: `_<app>-<credential-type>` t.ex. `authentik-postgres-credentials`
   - Fråga: "Föreslått namn: X. Är detta OK eller vill du använda något annat?"

2. **Namespace** (obligatoriskt)
   - Fråga vilken namespace secretet ska leva i
   - Eller föreslå baserat på komponent/context

3. **Secret-typ** (obligatoriskt)
   - `generic` - för vanliga key-value par (lösenord, API-nycklar, tokens)
   - `tls` - för TLS-certifikat och privata nycklar
   - `docker-registry` - för Docker-registry credentials

   **Typ-förslag baserat på användning:**
   - API-nyckel/lösenord/token → föreslå `generic`
   - Certifikat/privat nyckel → föreslå `tls`
   - Docker/Helm-registry → föreslå `docker-registry`

   Fråga: "Föreslått typ: X. Stämmer det?"

4. **Key-value pairs** (obligatoriskt för generic/docker-registry)

   För `generic`:
   - Fråga efter varje key och value
   - Visa sammanfattning: "Nu har du: key1=**_, key2=_**"
   - Fråga: "Lägga till fler keys? (ja/nej)"
   - Vid bekräftelse: "Dessa keys ser bra ut: ..."

   För `tls`:
   - Fråga efter cert- och key-filer, eller generera ett självsignerat

   För `docker-registry`:
   - Fråga efter: docker-server, username, password, email (valfritt)

5. **Mål-repo** (obligatoriskt - görs först!

   Fråga: "Vilket repo vill du spara secretet i?"

   Standard: `infrastructure` → `/home/simon/repos/infrastructure/`

   Möjliga alternativ:
   - `infrastructure` (standard)
   - Ange annat repo: `/home/simon/repos/<repo-name>`

   **OBS:** Detta avgör var vi letar efter SOPS-config och var vi sparar.

6. **Mål-mapp inom repot** (obligatoriskt)

   Fråga: "Var inom repot ska secretet sparas?"

   Hjälp användaren genom att visa möjliga mappar:

   **För infrastructure-repot:**

   ```
   components/atlas-operator/, components/authentik/, components/cert-manager/,
   components/cloudflared/, components/cloudnative-pg/, components/dot-ai/,
   components/envoy/, components/flux/, components/kyverno/,
   components/longhorn-system/, components/metallb/, components/secrets/,
   components/zitadel/
   ```

   **För andra repon:**
   - Lista repons root-mappar: `ls /home/simon/repos/<repo>/`
   - Leta efter befintliga secrets-mappar

   Fråga: "Föreslått: <relevant-mapp baserat på context>. Stämmer det?"

### Steg 3: Generera och kryptera

**A. Skapa temporär Secret YAML**

Använd kubectl för att generera basstrukturen:

```bash
kubectl create secret generic <name> \
  --from-literal=key1=value1 \
  --from-literal=key2=value2 \
  -n <namespace> \
  -o yaml > /tmp/secret-temp.yaml
```

**B. Kryptera med SOPS**

```bash
sops --encrypt \
  --age age1mv3yrgdtqddlr5v9tg67nydvztm3sm6r3uu3j9zhdp736p0wt5gqwyj9lt \
  --encrypted-regex '^(stringData|data)$' \
  --output <destination>.yaml \
  /tmp/secret-temp.yaml
```

**C. Flytta till slutlig destination**

```bash
mv /tmp/<name>.yaml <repo-path>/<target-folder>/
```

Exempel:

```bash
mv /tmp/minio-credentials.enc.yaml /home/simon/repos/infrastructure/infrastructure-flux/components/minio/
```

### Steg 4: Verifiera

**Visa användaren det krypterade resultatet:**

1. Visa filvägen där secretet sparades
2. Decrypta och visa innehållet för verifiering (utan att visa känsliga värden):
   ```bash
   SOPS_AGE_KEY=$(op item get "SOPS" --reveal --fields label="SOPS Private Key")
   sops -d <filväg>
   ```

**Säkerhetsmeddelande:**

- Påminn användaren att hemligheterna nu är krypterade i Git
- Flux kommer automatiskt decrypta vid apply till klustret
- Commit och push för att distribuera

## Exempel-prompts för att testa

**Test 1: Enkel API-nyckel** "Användaren: Jag behöver ett nytt secret för MinIO
med en access key och secret key"

**Test 2: TLS-certifikat** "Användaren: Skapa ett TLS-secret för min ingress med
ett wildcard-certifikat"

**Test 3: Docker-registry** "Användaren: Jag behöver credentials för att hämta
images från vår privata Docker Hub"

## Vanliga secret-namn att föreslå

| Användning        | Föreslått namn               |
| ----------------- | ---------------------------- |
| MinIO credentials | `minio-credentials`          |
| PostgreSQL        | `<app>-postgres-credentials` |
| LDAP              | `ldap-bind-password`         |
| SMTP/Email        | `smtp-credentials`           |
| API-tokens        | `<service>-api-token`        |
| OAuth/OIDC        | `<app>-oauth-credentials`    |

## Filstruktur

### Infrastructure-repot

```
/home/simon/repos/infrastructure/
├── infrastructure-flux/components/
│   ├── secrets/
│   │   ├── sops.age.pub          # Publika age-nyckeln (okrypterad)
│   │   └── *.enc.yaml            # Krypterade secrets
│   └── <component>/              # Komponentspecifika secrets
│       └── *.enc.yaml
└── .sops.yaml                    # SOPS-konfiguration (om den finns)
```

### Andra repon

```
/home/simon/repos/<repo>/
├── secrets/                     # Eller annan hemlighets-mapp
│   ├── *.age.pub                 # Publika nycklar
│   └── *.enc.yaml                # Krypterade secrets
└── .sops.yaml                    # SOPS-konfiguration
```

## Säkerhetspraxis

- **Aldrig** visa eller logga plaintext secrets
- **Alltid** kryptera med PUBLIKA nyckeln (aldrig den privata)
- Secrets ska **aldrig** committas okrypterade
- Använd `openssl rand -base64 32` för att generera säkra lösenord

## Verktyg som behövs

- `sops` - SOPS CLI
- `kubectl` - Kubernetes CLI
- `age` eller `sops` med age-stöd

## Felsökning

### "sops: error: unknown flag: --age"

Uppdatera SOPS: `brew upgrade sops` eller installera senaste versionen.

### "Failed to encrypt"

Kontrollera att age-nyckeln är korrekt:
`age1mv3yrgdtqddlr5v9tg67nydvztm3sm6r3uu3j9zhdp736p0wt5gqwyj9lt`
