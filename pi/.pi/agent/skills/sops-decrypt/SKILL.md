---
name: sops-decrypt
description: |
  Dekryptera SOPS-krypterade filer med age-nycklar från 1Password.
  Utlösare: "sops", "sops decrypt", "dekryptera secrets", "sops -d", 
  "decrypt sops", "sops secret", "SOPS_AGE_KEY", "sops encrypted"
---

# SOPS Decrypt Skill

Denna skill hanterar dekryptering av SOPS-krypterade filer i den här
GitOps-miljön.

## Arbetsflöde

### 1. Hämta SOPS-nyckeln från 1Password

```bash
SOPS_AGE_KEY=$(op item get "SOPS" --reveal --fields label="SOPS Private Key")
```

Detta hämtar den privata age-nyckeln från 1Password-valvet. Nyckeln sparas i
`SOPS_AGE_KEY`-miljövariabeln.

### 2. Dekryptera SOPS-filen

```bash
sops -d <sökväg-till-krypterad-fil>
```

Flaggan `-d` betyder "decrypt". Exempel:

```bash
sops -d environments/permanent/prod/secrets/auth.enc.yaml
```

### 3. Kombinera i ett steg (rekommenderat)

För att undvika att nyckeln syns i shell-historiken:

```bash
SOPS_AGE_KEY=$(op item get "SOPS" --reveal --fields label="SOPS Private Key") sops -d <fil>
```

## Vanliga filvägar

Typiska SOPS-krypterade filer i denna miljö:

- `environments/permanent/prod/secrets/*.enc.yaml`
- `infrastructure/infrastructure-flux/components/secrets/*.enc.yaml`
- Kluster-specifika secrets i respektive klustermapp

## Säkerhetspraxis

- **Visa aldrig** `SOPS_AGE_KEY` i output eller loggar
- Använd aldrig `echo $SOPS_AGE_KEY` eller liknande
- Miljövariabeln är session-specifik och syns inte i processlistan
- Nyckeln behövs endast för dekryptering, inte för kryptering (Flux sköter det)

## Felsökning

### "Failed to get the item" (1Password)

Kontrollera att:
- 1Password CLI (`op`) är installerad och autentiserad
- Objektet "SOPS" finns i valvet
- Fältet heter exakt "SOPS Private Key"

### "Error decrypting: no key found"

Kontrollera att:
- Filen verkligen är krypterad med SOPS (`.enc.yaml`-suffix)
- Age-nyckeln är korrekt och matchar den som användes för kryptering