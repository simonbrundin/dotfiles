# HelmRelease ArtifactFailed Debug (with_skill)

## User Query
"Ett HelmRelease för cert-manager har ArtifactFailed. Hur felsöker jag detta?"

## Diagnostic Approach

### Step 1: Describe HelmRelease
```bash
kubectl describe helmrelease cert-manager -n cert-manager
```

Look for:
- Conditions showing which phase failed
- Artifact failure reason
- Related resources status

### Step 2: Check helm-controller logs
```bash
kubectl logs -n flux-system -l app=helm-controller --tail=200
```

Look for "chart not found" or "download failed" errors.

### Step 3: Verify the source
In your setup, cert-manager uses OCIRepository:
```bash
kubectl describe ocirepository cert-manager-source -n flux-system
```

Or if it uses HelmRepository:
```bash
kubectl describe helmrepository cert-manager -n flux-system
```

### Step 4: Force reconcile
```bash
flux reconcile helmrelease cert-manager -n cert-manager
```

## Your Infrastructure
- Source: `components/cert-manager/source.yaml`
- OCIRepository or HelmRepository depending on setup