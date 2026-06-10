---
name: component-debug
description: >
  Felsök och reparera Kubernetes-klusterkomponenter via Flux GitOps.
  Utlösare: "felsök <komponent>", "fixa <komponent>", "reparera <komponent>",
  "component-debug", "debug component", "komponent felsökning", "repa flux",
  "sync component", "flux debug component", "longhorn degraded", "flux not ready".
  Använd när användaren behöver felsöka, reparera eller synca en specifik
  Kubernetes-komponent i klustret. Inkluderar automatiska fix-skript, 
  health scoring och parallell diagnostik.
---

# Kubernetes Component Debug & Repair Skill

Felsök, reparera och synca Kubernetes-klusterkomponenter via Flux GitOps.
Denna skill kombinerar lokal YAML-hämtning, klusterdiagnostik, testning och
automatisk reparation.

## Arbetsflöde

Denna skill följer ett strukturerat arbetsflöde:

```
┌─────────────────────────────────────────────────────────────┐
│  1. LÄS YAML    →  Läs lokala YAML-filer från components/  │
│                     ↓                                      │
│  2. PARALLELL  →  Hämta klusterdata (pods, flux, events)   │
│     HÄMTNING       samtidigt för hastighet                  │
│                     ↓                                      │
│  3. HEALTH      →  Beräkna health score (0-100%)          │
│     SCORE                                        │
│                     ↓                                      │
│  4. DIAGNOSERA  →  Mappa symptom → specifik lösning        │
│     MED BESLUTSTRÄD                                      │
│                     ↓                                      │
│  5. ÄNDRA YAML  →  Applicera ändringar lokalt               │
│                     ↓                                      │
│  6. DRY-RUN     →  Förhandsgranska ändringar (valfritt)   │
│                     ↓                                      │
│  7. COMMIT/PUSH →  Commit och pusha till git                │
│                     ↓                                      │
│  8. ÖVERVAKA    →  Watch resurser tills uppdaterade        │
│                     ↓                                      │
│  9. VERIFIERA   →  Kör tester, vid fel → retry (max 3x)   │
└─────────────────────────────────────────────────────────────┘
```

## Health Score

Beräkna en health score (0-100%) för komponenten:

| Del | Vikt | Kontrollerar |
|-----|------|-------------|
| Pods | 30% | Alla Running, inga CrashLoop |
| Flux Sources | 25% | Alla Ready |
| Flux Kustomizations | 25% | Alla Reconciled |
| Events | 20% | Inga Error/Warning |

## Verktyg och Kommandon

### Kärn-kommandon

```bash
# Lista tillgängliga komponenter
ls ~/repos/infrastructure/infrastructure-flux/components/

# Läs YAML för en specifik komponent
cat ~/repos/infrastructure/infrastructure-flux/components/<component>/*.yaml

# Hämta Flux-resurser relaterade till komponent
flux get all -n <namespace>

# Rekonciliera en kustomization
flux reconcile kustomization <name> -n <namespace>

# Övervaka resurser
kubectl get <resource> -n <namespace> -w

# Kontrollera flux events
flux logs --kind=Kustomization --name=<name>
```

### Flux CLI Verktyg

```bash
# Flux käll-lista
flux get sources oci -A
flux get sources helm -A
flux get sources git -A

# Flux kustomizations
flux get kustomizations -A

# Flux HelmReleases
flux get helmreleases -A

# Tvinga rekonciliation
flux reconcile kustomization <name> -n <namespace> --with-source

# Dependency-träd
flux tree kustomization <name> -n <namespace>
```

## Komponent-specifik Felsökning

### Flux

```bash
# Kontrollera Flux-system
kubectl get pods -n flux-system
kubectl get gitrepositories -A
kubectl get kustomizations -A

# Rekonciliera Flux-komponent
flux reconcile kustomization flux -n flux-system --force
flux reconcile source git flux-system -n flux-system --force
```

### Longhorn

```bash
# Longhorn-volymer
kubectl get volumes -n longhorn-system
kubectl get nodes.longhorn.io -n longhorn-system

# Longhorn hälsa
simon kubernetes longhorn test

# Longhorn reparations
simon kubernetes longhorn repair
```

### cert-manager

```bash
# Cert-manager pods
kubectl get pods -n cert-manager

# Certificate status
kubectl get certificates -A
kubectl get clusterissuers -A

# Certificate details
kubectl describe certificate <name> -n <namespace>
```

### CloudNativePG

```bash
# CNPG clusters
kubectl get clusters.postgresql.cnpg.io -A

# Backups
kubectl get backups.postgresql.cnpg.io -A

# Poolers
kubectl get poolers.postgresql.cnpg.io -A
```

### Metallb

```bash
# Metallb IPAddressPools
kubectl get ipaddresspools.metallb.io -A
kubectl get l2advertisements.metallb.io -A

# Metallb speakers
kubectl get pods -n metallb-system
```

### Vault

```bash
# Vault status
kubectl exec -n vault <pod> -- vault status

# Vault unseal
kubectl get pods -n vault -l vault-active=true
```

### External Secrets (ESO)

```bash
# ExternalSecrets
kubectl get externalsecrets -A
kubectl get clusterexternalsecret -A

# SecretStores
kubectl get secretstores -A
```

## Test-mall

Skapa tester som verifierar komponentens hälsa:

```bash
# Exempel: Verifiera att alla pods är Running
kubectl get pods -n <namespace> --no-headers | grep -v Running | wc -l

# Exempel: Verifiera att inga CrashLoopBackOff finns
kubectl get pods -n <namespace> -o jsonpath='{.items[*].status.phase}' | grep -v Running

# Exempel: Verifiera Flux Kustomization är Reconciled
flux get kustomizations -A | grep -v Reconciled | tail -n +2 | wc -l
```

## Steg-för-Steg Process

### Steg 1: Identifiera Komponent

Användaren anger komponenten som ska felsökas. Mappera till rätt namespace
och kustomization:

| Komponent | Namespace | Kustomization |
|-----------|-----------|--------------|
| flux | flux-system | flux |
| longhorn | longhorn-system | longhorn-system |
| cert-manager | cert-manager | cert-manager |
| cloudnative-pg | cnpg-system | cloudnative-pg |
| metallb | metallb-system | metallb |
| vault | vault | secrets |
| external-secrets | external-secrets | secrets |

### Steg 2: Läs Lokal Konfiguration

```bash
# Läs alla YAML-filer för komponenten
COMPONENT=<component>
COMPONENT_DIR=~/repos/infrastructure/infrastructure-flux/components/$COMPONENT

ls -la $COMPONENT_DIR/
cat $COMPONENT_DIR/kustomization.yaml

for f in $COMPONENT_DIR/*.yaml; do
  echo "=== $f ===" && cat "$f"
done
```

### Steg 3: Hämta Kluster-status

```bash
# Flux sources för komponenten
flux get sources -A | grep -E "(<namespace>|<component>)"

# Kustomizations
flux get kustomizations -A | grep -E "(<namespace>|<component>)"

# HelmReleases
flux get helmreleases -A | grep <namespace>

# Pods i namespace
kubectl get pods -n <namespace>

# Events
kubectl events -n <namespace> --types Warning,Error | tail -50
```

### Steg 4: Analysera och Diagnostisera (Beslutsträd)

Jämför lokal YAML med kluster-status. Använd beslutsträdet:

```
┌─────────────────┐
│ Pod-problem?    │
└────────┬────────┘
         │
    ┌────┴────┐
    ▼         ▼
  Ja        Nej
    │         │
    ▼         ┌─────────────────┐
  CrashLoop   │ Flux-problem?    │
    │         └────────┬────────┘
    ▼            ┌────┴────┐
  1. Beskriv pod  │         │
  2. Kolla logs   ▼         ▼
  3. Restart cnt  Ja       Nej
    │              │         │
    ▼              ▼         ▼
  ImagePull      Source     HelmRelease
    │           not Ready     Failed
    ▼              │         │
  Fix image      Check      Check chart
                 creds      & values

  Pod Pending?   DependencyNotReady?
    │                 │
    ▼                 ▼
  1. Resources    1. flux tree
  2. Scheduling  2. Rekonciliera
  3. NodeReady   3. dependencies
```

### Steg 5: Automatisk Fix

Använd fix-skript för vanliga problem:

```bash
# Kör automatiskt fix-script om problem identifierat
~/.pi/agent/skills/component-debug/scripts/fix_component.sh <component> <problem_type>

# Fix-typer:
# - "crashloop" → Fixa CrashLoopBackOff
# - "imagepull" → Fixa ImagePullBackOff
# - "notready" → Fixa NotReady-resurser
# - "dependency" → Fixa DependencyNotReady
# - "drift" → Synca drifter
```

### Steg 6: Dry-Run (valfritt)

Innan ändringar, visa en preview:

```bash
# Visa diff utan att applicera
git diff components/<component>/

# Flux drift detection
flux diff kustomization <name> -n <namespace> --no-coalesce
```

Om ändringar behövs:

```bash
# 1. Redigera YAML-filerna
nano ~/repos/infrastructure/infrastructure-flux/components/<component>/<file>.yaml

# 2. Commit och push
cd ~/repos/infrastructure
git add components/<component>/
git commit -m "fix(<component>): <description of fix>"
git push

# 3. Rekonciliera
flux reconcile kustomization <kustomization-name> -n <namespace> --with-source
```

### Steg 7: Övervaka och Verifiera

```bash
# Health score före (0-100%)
echo "Health score före fix: $(~/.pi/agent/skills/component-debug/scripts/health_score.sh <namespace>)%"

# Watch resurser tills uppdaterade (timeout 120s)
timeout 120 kubectl get kustomization <name> -n <namespace> -w

# Health score efter
sleep 30
NEW_SCORE=$(~/.pi/agent/skills/component-debug/scripts/health_score.sh <namespace>)
echo "Health score efter fix: $NEW_SCORE%"

# Förbättring
if [ "$NEW_SCORE" -gt "$OLD_SCORE" ]; then
  echo "✅ Förbättring: +$((NEW_SCORE - OLD_SCORE))%"
fi
```

### Steg 8: Kör Verifieringstester

Kör tester och verifiera att allt fungerar:

```bash
# Kör test_script
~/.pi/agent/skills/component-debug/scripts/test_component.sh <component> <namespace>

# Eller inline:
# Test: Pods är Running
NOT_RUNNING=$(kubectl get pods -n <namespace> -o json | jq -r '.items[] | select(.status.phase != "Running") | .metadata.name' | wc -l)
[ "$NOT_RUNNING" -eq 0 ] && echo "✅ Alla pods Running" || echo "❌ $NOT_RUNNING pods inte Running"

# Test: Flux Kustomization är Reconciled
RECONCILED=$(flux get kustomizations -A | grep <namespace> | grep -c Reconciled || echo 0)
TOTAL=$(flux get kustomizations -A | grep <namespace> | wc -l || echo 0)
[ "$RECONCILED" -eq "$TOTAL" ] && echo "✅ Alla kustomizations Reconciled" || echo "❌ $RECONCILED/$TOTAL Reconciled"
```

### Steg 8: Retry-logik

Om tester misslyckas:

1. **Första försöket**: Logga felet, kör diagnosticering igen
2. **Andra försöket**: Fördjupa analysen, applicera fler fixes
3. **Tredje försöket**: Sist försöket med mer aggressiv reparation
4. **Efter 3 misslyckanden**: Avbryt och rapportera misslyckande med
   detaljerad information om vad som provats

## Exempel Användning

### "Felsök Flux"

```
Användare: felsök flux
Agent: Läser ~/repos/infrastructure/infrastructure-flux/components/flux/
      → Hämtar flux get all -A
      → Skriver tester
      → Diagnostiserar problem
      → Fixar och pushar
      → Övervakar tills stabil
      → Verifierar med tester
```

### "Reparera longhorn-system"

```
Användare: reparera longhorn
Agent: Läser longhorn YAML
      → Kontrollerar Longhorn-volymer och noder
      → Identifiear problem (t.ex. degraded volumes)
      → Ändrar kustomization.yaml med rätt settings
      → Committar och pushar
      → Rekoncilierar flux kustomization longhorn-system
      → Övervakar tills alla volymer är healthy
      → Verifierar med tester
```

## Felsöknings-kommandon Referens

### Flux Loglevel

```bash
# Sätt loglevel för controllers
flux logs --kind=source-controller --level=debug

# Töm loggar
flux logs --kind=Kustomization --name=<name> --previous
```

### Kluster-resurser

```bash
# Alla resurser i namespace
kubectl get all -n <namespace>

# Resource med YAML
kubectl get <resource> -n <namespace> -o yaml

# Events sorterade efter tid
kubectl get events -n <namespace> --sort-by='.lastTimestamp'
```

### Tail Logs

```bash
# Pod logs
kubectl logs -n <namespace> <pod> --tail=100

# Alla containrar
kubectl logs -n <namespace> <pod> --all-containers --tail=100

# Följ loggar
kubectl logs -n <namespace> <pod> -f
```

## Komponent-path Mappning

```
~/repos/infrastructure/infrastructure-flux/components/
├── atlas-operator/        → namespace: atlas-operator-system
├── authentik/            → namespace: auth
├── cert-manager/         → namespace: cert-manager
├── cloudflared/          → namespace: cloudflared
├── cloudnative-pg/       → namespace: cnpg-system
├── envoy/                → namespace: envoy-gateway
├── flux/                 → namespace: flux-system
├── kube-prometheus-stack/ → namespace: monitoring
├── kubelet-csr-approver/ → namespace: kubelet-csr-approver
├── kyverno/              → namespace: kyverno
├── longhorn-system/      → namespace: longhorn-system
├── metallb/              → namespace: metallb-system
├── metallb-address-resources/ → namespace: metallb-system
└── secrets/              → namespace: (vault, external-secrets)
```

## Output-format

När processen är klar, rapportera:

```
# Felsöknings-rapport: <komponent>

## Problem Identifierat
- [lista på problem]

## Åtgärder Vidtagna
- [lista på fixes]

## Verifiering
- ✅ Test 1: Passerade
- ✅ Test 2: Passerade

## Slutstatus
- Kustomization: Reconciled
- Pods: 3/3 Running
- Övervakning: Stabil i 60s
```

## Kommando-fil

Det finns ett hjälpskript för att automatisera delar av felsökningen:

```bash
~/repos/infrastructure/scripts/debug_component.sh <component>
```

Läs `references/troubleshooting.md` för detaljerade felsökningssteg.