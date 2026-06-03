# Flux GitRepository Debug Analysis (baseline - no skill)

## User Query
"Min flux-system gitrepository är inte Ready. Kan du hjälpa mig felsöka vad som är fel?"

## General Debugging Steps

Det här är ett Flux-problem. Här är några generella steg:

1. Kolla om gitrepository objektet finns
2. Beskriv det för att se events
3. Prova att rekonciliera det

```bash
kubectl get gitrepositories -n flux-system
kubectl describe gitrepository flux-system -n flux-system
flux reconcile source git flux-system -n flux-system
```

Troligen finns det ett auth-problem eller nätverksproblem.
