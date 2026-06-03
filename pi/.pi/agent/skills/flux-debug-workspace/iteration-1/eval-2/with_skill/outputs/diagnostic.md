# Kustomization DependencyNotReady Debug (with_skill)

## User Query
"Jag har en Kustomization som visar DependencyNotReady. Den har en dependency till flux-system gitrepository. Hur listar jag ut vad som är fel?"

## Diagnostic Approach

### Step 1: Trace dependencies with flux tree
```bash
flux tree kustomization <name> -n <namespace>
```

This shows the entire dependency graph. Look for:
- Which dependencies are not Ready
- What resource types are involved
- The chain of dependencies

### Step 2: Check all sources status
```bash
flux get sources -A
```

For your dependency (flux-system gitrepository):
```bash
kubectl describe gitrepository flux-system -n flux-system
```

### Step 3: Reconcile the dependency
```bash
flux reconcile source git flux-system -n flux-system --with-source
```

Then reconcile the Kustomization:
```bash
flux reconcile kustomization <name> -n <namespace>
```

## Understanding DependencyNotReady
This status means one of the sources your Kustomization depends on is not Ready.
Common causes:
1. GitRepository not synced (auth/network issues)
2. HelmRepository/OCIRepository not reachable
3. Cross-namespace dependency not available

## Quick Fix
```bash
# Fix the root dependency
flux reconcile source git flux-system -n flux-system

# Then force the dependent Kustomization
flux reconcile kustomization <name> -n <namespace>
```