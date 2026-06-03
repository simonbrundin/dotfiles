---
name: flux-debug
description: >
  Felsök FluxCD GitOps-operator i Kubernetes-kluster. Utlösare: "felsök flux",
  "flux problem", "flux fel", "flux issue", "flux debugging", "flux troubleshoot",
  "flux source", "flux kustomization", "flux helmrelease", "flux sync",
  "gitrepository not ready", "helmrelease failed", "flux drift". Använd alltid
  denna skill vid Flux-problem.
---

# FluxCD Felsöknings-skill

Felsök FluxCD-installationer i Kubernetes-kluster. Denna skill är optimerad för
infrastruktur-repo i `~/repos/infrastructure/` med Kustomize-overlays.

## Integrerad Tool-stack

Denna skill arbetar tillsammans med:

| Verktyg | Kommando | Används för |
|---------|----------|-------------|
| `simon cluster health` | `simon cluster health` | Snabb helhetsbild av Flux-status |
| Talos | `talosctl` | Nod-hälsa och networking |
| Longhorn | `simon kubernetes longhorn test` | Storage-relaterade problem |
| k9s | `k9s` | Interaktiv navigation av Flux-objekt |

## Snabb Felsökning

### Steg 1: Helhetsbild med `simon cluster health`

Kör alltid detta först för att få en sammanfattning:

```bash
simon cluster health
```

Detta visar status för:
- Flux controllers (source, kustomize, helm)
- Kustomizations (Reconciled/False)
- Flux Sources (Git, Helm, OCI)
- HelmReleases
- Pending CSRs

### Steg 2: Djupdykning med Flux CLI

```bash
# Alla Flux-objekt
flux get all -A

# Controllers
kubectl get pods -n flux-system

# Events
kubectl events -n flux-system --types Warning,Error | head -50
```

## Grundläggande Hälso-kontroll

```bash
# Flux CLI hälsa
flux check --verbose

# Alla Flux CRDs och deras status
kubectl get all -n flux-system

# Sammanfattning av flux-objekt
kubectl get gitrepositories,helmrepositories,ocirepositories,buckets,kustomizations,helmreleases -A

# Controller loggar
kubectl logs -n flux-system -l app=source-controller --tail=100
kubectl logs -n flux-system -l app=kustomize-controller --tail=100
kubectl logs -n flux-system -l app=helm-controller --tail=100
kubectl logs -n flux-system -l app=notification-controller --tail=100
```

## Source-felsökning

```bash
# GitRepository details
kubectl describe gitrepository <name> -n <namespace>

# OCIRepository (OCI-sources används för Helm-charts)
kubectl describe ocirepository <name> -n <namespace>

# Source status med villkor
kubectl get gitrepository <name> -n <namespace> -o jsonpath='{.status}'

# Artifact/commit som är syncat
kubectl get gitrepository <name> -n <namespace> -o jsonpath='{.status.artifact}'

# Check git credentials (SSH-keys)
kubectl get secret flux-git-ssh-key -n flux-system

# Rekonciliera source manuellt
flux reconcile source git <name> -n <namespace> --with-source
flux reconcile source oci <name> -n <namespace> --with-source

# Loggar
flux logs --kind=GitRepository --name=<name> -n <namespace>
flux logs --kind=OCIRepository --name=<name> -n <namespace>
```

**Din infrastruktur:**
- SSH GitRepository → `clusters/production/flux-system/gitrepository.yaml`
- OCI Sources → `components/*/ocirepository.yaml`

## Kustomize/HelmRelease felsökning

```bash
# Kustomization status
kubectl get kustomization <name> -n <namespace> -o jsonpath='{.status}'

# Senaste reconciliation
kubectl describe kustomization <name> -n <namespace>

# HelmRelease felsökning
kubectl describe helmrelease <name> -n <namespace>
kubectl get helmrelease <name> -n <namespace> -o jsonpath='{.status}'

# Drift detection
flux diff kustomization <name> --no-coalesce -n <namespace>

# Trace dependencies
flux tree kustomization <name> -n <namespace>

# Tvinga rekonciliation
flux reconcile kustomization <name> -n <namespace>
flux reconcile helmrelease <name> -n <namespace>
```

## Vanliga Fel och Åtgärder

| Felmeddelande | Orsak | Åtgärd |
|--------------|-------|--------|
| `authentication required` | SSH-key saknas eller fel | Verifiera `flux-git-ssh-key` Secret |
| `authentication failed` | Fel credentials | Kolla Secret i samma namespace |
| `branch 'main' not found` | Branch finns inte | Verifiera branch-namn i GitRepository |
| `unable to clone` | Nätverk/SSH | Testa med `ssh -T git@github.com` |
| `chart not found` | Fel chart/version | Verifiera HelmRepository/OCIRepository |
| `DependencyNotReady` | Beroende source inte klar | `flux tree` för att se beroenden |
| `ArtifactFailed` | Download/extract misslyckades | `flux logs --kind=HelmRelease` |
| `run过我 inte reconciliation` | Rate limiting | Öka interval eller vänta |
| `Forbidden` | RBAC | Verifiera ServiceAccount och ClusterRole |

## Symptom-baserad Felsökning

### Source är "NotReady"

```bash
# 1. Beskriv och kolla status
kubectl describe gitrepository <name> -n flux-system

# 2. Kolla loggar
flux logs --kind=GitRepository --name=<name> -n flux-system

# 3. Verifiera SSH-åtkomst
ssh -T git@github.com

# 4. Verifiera credentials
kubectl get secret flux-git-ssh-key -n flux-system -o yaml
```

### Kustomization är "DependencyNotReady"

```bash
# 1. Visa dependency-träd
flux tree kustomization <name> -n <namespace>

# 2. Kolla varje dependency
flux get sources -A

# 3. Rekonciliera dependencies
flux reconcile source git flux-system -n flux-system --with-source
```

### HelmRelease är "ArtifactFailed"

```bash
# 1. Detaljer om felet
kubectl describe helmrelease <name> -n <namespace>

# 2. Loggar från helm-controller
kubectl logs -n flux-system -l app=helm-controller --tail=200

# 3. Verifiera source
kubectl describe ocirepository <name> -n flux-system
# eller
kubectl describe helmrepository <name> -n flux-system
```

### Drift Detected

```bash
# Visa ändringar
flux diff kustomization <name> -n <namespace>

# Om ändringarna är avsiktliga, synca
flux reconcile kustomization <name> -n <namespace>

# Om det är ett problem, kolla källan
flux logs --kind=Kustomization --name=<name>
```

## Flux CLI-verktyg

```bash
# Fullständig Flux-klient-status
flux linter

# Export/import av Flux resources
flux export source git --all > sources.yaml
flux export kustomization --all > kustomizations.yaml

# Trace dependencies
flux tree kustomization <name> -n <namespace>

# Version och status
flux version
flux stats

# Force refresh
flux reconcile source <type>/<name> --force -n <namespace>
```

## Din Infrastructure Setup

### Filstruktur

```
~/repos/infrastructure/infrastructure-flux/
├── apps/                    # Flux-applikationer
├── clusters/production/      # Kluster-konfiguration
│   └── flux-system/
│       └── gitrepository.yaml  # Huvud-GitRepository (SSH)
├── components/              # Återanvändbara komponenter
│   ├── cert-manager/
│   ├── cloudnative-pg/
│   ├── flux/
│   ├── kube-prometheus-stack/
│   ├── longhorn-system/
│   ├── metallb/
│   └── secrets/
└── flux-system/             # Flux bootstrap
```

### Typer av Sources

| Typ | Exempel | Används för |
|-----|----------|-------------|
| GitRepository (SSH) | `flux-system` i flux-system namespace | Huvud-repo |
| OCIRepository | `envoy-gateway` i flux-system | Helm-charts från OCI registries |
| HelmRepository | `bitnami` etc. | Traditionella Helm repos |

### Secrets

```bash
# SSH-key för GitRepository
kubectl get secret flux-git-ssh-key -n flux-system -o yaml

# Kolla om det finns i 1Password
op read "op://..."
```

## Interaktiv Navigation

För interaktiv felsökning, använd k9s:

```bash
# Poddar i flux-system
k9s -c 'pods' -n flux-system

# Eller alla Flux-objekt
k9s
# Navigera med :git<ENTER> för GitRepositories
# :oci<ENTER> för OCIRepositories
# :kust<ENTER> för Kustomizations
```

## Exempel Användningsfall

### "Flux hittar inte min git-branch"
1. Kör `simon cluster health` för sammanfattning
2. `kubectl describe gitrepository flux-system -n flux-system`
3. Verifiera branch-namn i `clusters/production/flux-system/gitrepository.yaml`
4. `ssh -T git@github.com` för att testa SSH

### "HelmRelease deployar fel version"
1. `kubectl describe helmrelease <name> -n <namespace>`
2. Kolla artifact i `status.history`
3. `flux reconcile helmrelease <name> -n <namespace>`

### "Kustomization har dependency-fel"
1. `flux tree kustomization <name> -n <namespace>`
2. Verifiera varje source är `Ready`
3. `flux reconcile source git <dep-name> -n <dep-namespace>`

### "Flux loggar visar auth-fel"
1. Verifiera `flux-git-ssh-key` finns och är korrekt
2. `kubectl logs -n flux-system -l app=source-controller`
3. Testa SSH manuellt

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
- `OCIRepository` (source.toolkit.fluxcd.io)
- `Bucket` (source.toolkit.fluxcd.io)
- `Kustomization` (kustomize.toolkit.fluxcd.io)
- `HelmRelease` (helm.toolkit.fluxcd.io)
- `ImagePolicy`, `ImageUpdateAutomation`, `ImageRepository`
  (image.toolkit.fluxcd.io)
- `Provider`, `Alert`, `Receiver` (notification.toolkit.fluxcd.io)