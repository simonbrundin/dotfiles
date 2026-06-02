---
name: flux-debug
description: >
  Felsök FluxCD GitOps-operator i Kubernetes-kluster. Utlösare: "felsök flux",
  "flux problem", "flux fel", "flux issue", "flux symptom", "flux debugging",
  "flux troubleshoot". Inkluderar Flux v2 API, kustomize, helm-controller,
  source-controller, notification-controller, och vanliga fel.
---

# FluxCD Felsöknings-skill

Felsök FluxCD-installationer i Kubernetes-kluster.

## När Använda Denna Skill

Denna skill triggas vid alla felsökningsförfrågningar relaterade till:

- FluxCD installation och uppgradering
- GitRepository, HelmRepository, Bucket sources
- Kustomize/HelmReleases som inte syncar
- Source-controller problem (credential-hantering, webhook-fel)
- Notification-controller (alertar, provider-konfiguration)
- Image automation och updater
- Flux API-objekt och deras statusvillkor
- Flux CLI-kommandon (`flux check`, `flux logs`, `flux reconcile`)

## Diagnostik-kommandon

### Grundläggande hälso-kontroll

```bash
# Flux hälsa i klustret
flux check --verbose

# Alla Flux CRDs och deras status
kubectl get all -n flux-system

# Sammanfattning av flux-objekt
kubectl get gitrepositories,helmrepositories,buckets,kustomizations,helmreleases -A

# Flux controllers loggar
kubectl logs -n flux-system -l app=source-controller --tail=100
kubectl logs -n flux-system -l app=kustomize-controller --tail=100
kubectl logs -n flux-system -l app=helm-controller --tail=100
kubectl logs -n flux-system -l app=notification-controller --tail=100

# Flux events (fel/warning)
kubectl events -n flux-system --types Warning,Error | head -50
```

### Source-felsökning

```bash
# GitRepository details
kubectl describe gitrepository <name> -n <namespace>

# Visa source status med villkor
kubectl get gitrepository <name> -n <namespace> -o jsonpath='{.status}'

# Replica status
kubectl get gitrepository <name> -n <namespace> -o jsonpath='{.status.artifact}'

# Check git credentials
kubectl get secret <secret-name> -n <namespace> -o yaml

# Rekoncilera source manuellt
flux reconcile source git <name> -n <namespace> --with-source

# Visa commit som är syncat
flux logs --kind=GitRepository --name=<name> -n <namespace>
```

### Kustomize/HelmRelease felsökning

```bash
# Kustomization status
kubectl get kustomization <name> -n <namespace> -o jsonpath='{.status}'

# Senaste reconciliation-resultat
kubectl describe kustomization <name> -n <namespace>

# HelmRelease felsökning
kubectl describe helmrelease <name> -n <namespace>
kubectl get helmrelease <name> -n <namespace> -o jsonpath='{.status}'

# Drift detection (ändringar som inte applicerats)
flux diff kustomization <name> --no-coalesce -n <namespace>

# Tvinga rekonciliation
flux reconcile kustomization <name> -n <namespace>
flux reconcile helmrelease <name> -n <namespace>
```

### Vanliga felsöknings-scenarier

```bash
# 1. Source hittar inte git-ref
flux logs --kind=GitRepository | grep -i "reference"
# Lösning: Verifiera branch/commit exist i remote repo

# 2. Helm chart inte hittad
flux logs --kind=HelmRepository | grep -i "chart"
# Lösning: Verifiera chart name, version, och repository URL

# 3. RBAC-problem
kubectl auth can-i get gitrepositories -n flux-system
# Lösning: Kontrollera ServiceAccount och ClusterRole-bindings

# 4. Image updater fungerar inte
kubectl get imageupdateautomations -A
kubectl describe imageupdateautomation <name> -n <namespace>
# Lösning: Verifiera image scanning och commit-back konfiguration
```

### Flux CLI-verktyg

```bash
# Fullständig Flux-klient-status
flux linter

# Export/import av Flux resources
flux export source git --all > sources.yaml
flux export kustomization --all > kustomizations.yaml
flux import source git -f sources.yaml
flux import kustomization -f kustomizations.yaml

# Trace dependencies
flux tree kustomization <name> -n <namespace>

# Visa Flux-version och bootstrap-status
flux version
flux stats
```

## Vanliga Problem och Åtgärder

| Symptom                               | Diagnos                          | Åtgärd                                 |
| ------------------------------------- | -------------------------------- | -------------------------------------- |
| Source är "NotReady"                  | `kubectl describe gitrepository` | Verifiera credentials, URL, och branch |
| Kustomization är "DependencyNotReady" | `flux tree kustomization`        | Säkerställ dependencies är klara       |
| HelmRelease är "ArtifactFailed"       | `kubectl describe helmrelease`   | Verifiera chart version och values     |
| Reconciliation tar för länge          | `flux logs --kind=Kustomization` | Check rate limiting, öka interval      |
| Drift detected                        | `flux diff kustomization`        | Acceptera ändringar eller synca        |

## CRD Översikt

FluxCRDs installerade i klustret:

- `GitRepository` (source.toolkit.fluxcd.io)
- `HelmRepository` (source.toolkit.fluxcd.io)
- `Bucket` (source.toolkit.fluxcd.io)
- `Kustomization` (kustomize.toolkit.fluxcd.io)
- `HelmRelease` (helm.toolkit.fluxcd.io)
- `ImagePolicy`, `ImageUpdateAutomation`, `ImageRepository`
  (image.toolkit.fluxcd.io)
- `Provider`, `Alert`, `Receiver` (notification.toolkit.fluxcd.io)

## Filstruktur för Flux i Infrastructure Repo

```
/home/simon/repos/infrastructure/infrastructure-flux/components/flux/
├── base/
│   ├── kustomization.yaml
│   └── gitrepository.yaml
└── overlays/<env>/
    └── kustomization.yaml
```

Flux-konfiguration i detta repo hanteras via Kustomize-overlays.

## Exempel Användningsfall

- "Flux hittar inte min git-branch" → Kör diagnostik, verifiera ref i
  GitRepository
- "HelmRelease deployar fel version" → Check chart i HelmRepository, forcing
  reconcile
- "Kustomization har dependency-fel" → Använd `flux tree` för att se beroenden
- "Flux loggar visar auth-fel" → Verifiera Secret med git credentials
