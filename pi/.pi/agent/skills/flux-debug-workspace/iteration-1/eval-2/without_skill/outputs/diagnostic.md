# Kustomization DependencyNotReady Debug (baseline)

## User Query
"Jag har en Kustomization som visar DependencyNotReady. Den har en dependency till flux-system gitrepository. Hur listar jag ut vad som är fel?"

## General Steps

DependencyNotReady betyder att en dependency inte är klar.

1. Lista dependencies
2. Kolla varje en för sig

```bash
kubectl get kustomization <name> -n <namespace> -o yaml
# Look at .spec.dependsOn
flux get sources -A
```

Det finns nog ett problem med gitrepository som dependency.