# Flux GitRepository Debug Analysis (with_skill)

## User Query
"Min flux-system gitrepository är inte Ready. Kan du hjälpa mig felsöka vad som är fel?"

## Diagnostic Approach

### Step 1: Check GitRepository status
```bash
kubectl describe gitrepository flux-system -n flux-system
```

Key things to look for:
- Status conditions (Ready: True/False)
- Last successful revision
- Artifact URL and commit SHA
- Events showing authentication or network errors

### Step 2: Check source-controller logs
```bash
kubectl logs -n flux-system -l app=source-controller --tail=100
```

Look for:
- "authentication failed" → check Secret
- "branch not found" → verify branch name
- "unable to clone" → network/SSH issue

### Step 3: Verify SSH connectivity
```bash
ssh -T git@github.com
```

If this fails, the SSH key in flux-git-ssh-key is invalid.

### Step 4: Verify credentials Secret
```bash
kubectl get secret flux-git-ssh-key -n flux-system -o yaml
```

The Secret must contain:
- `known_hosts` (for GitHub host verification)
- `identity` (private SSH key)
- `identity.pub` (public SSH key)

## Your Infrastructure Context
- GitRepository: `clusters/production/flux-system/gitrepository.yaml`
- Secret: `flux-git-ssh-key` in flux-system namespace
- URL: `ssh://git@github.com/simonbrundin/infrastructure`
- Branch: `main`

## Quick Fix Commands
```bash
# Force reconcile
flux reconcile source git flux-system -n flux-system --with-source

# Check events
kubectl events -n flux-system --types Warning,Error | grep -i gitrepository
```
