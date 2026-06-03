# HelmRelease ArtifactFailed Debug (baseline)

## User Query
"Ett HelmRelease för cert-manager har ArtifactFailed. Hur felsöker jag detta?"

## General Steps

HelmRelease har misslyckats. Prova:

1. Beskriv HelmRelease för events
2. Kolla helm-controller logs
3. Verifiera att source (HelmRepository/OCIRepository) är Ready

```bash
kubectl describe helmrelease cert-manager -n cert-manager
kubectl logs -n flux-system -l app=helm-controller
```

Det kan vara att chartten inte finns eller att det är ett versionsproblem.