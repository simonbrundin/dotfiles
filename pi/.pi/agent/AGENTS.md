# Riktlinjer för agenter

Det här dokumentet ger kontext för AI-agenter som arbetar i den här miljön.

## On-Prem Miljö

### Kubernetes & GitOps-upplägg

Miljön använder ett GitOps-arbetssätt med:

- **Flux**: GitOps-operator för deklarativ infrastrukturhantering
- **Kustomize**: Konfigurationshantering med base/overlay-mönster

### Infrastruktur-repository

- **Infrastructure**: `~/repos/infrastructure/`
  - Innehåller all klusterkonfiguration, appar och komponenter
  - Alla manifests som flux hanterar finns i infrastructure-flux/

### Mappstruktur för manifests

```
infrastructure/infrastructure-flux/
├── apps/                    # Flux-applikationer kustomizations
├── clusters/production/      # Produktionskluster-konfiguration
├── components/              # Återanvändbara komponenter
│   ├── cert-manager/
│   ├── cloudnative-pg/
│   ├── flux/                # Flux bootstrap & konfiguration
│   ├── kube-prometheus-stack/
│   ├── longhorn-system/     # Beständig lagring
│   ├── metallb/             # Lastbalansering
│   └── secrets/             # Sekretesshantering (SOPS)
└── flux-system/             # Flux systemkonfiguration
```

### Flux & GitOps-arbetssätt

- Alla klusterändringar går via Flux (ingen direkt `kubectl apply` till
  klustret)
- Ändringar committas till git och Flux synkar dem automatiskt
- Hemligheter är krypterade med SOPS och sparade i databasen
- Flux är installerat via [Flux Operator](https://fluxoperator.dev/docs)

- Infrastrukturen hanteras separat via GitOps-arbetssättet
- Lokala konfigurationer (shell, editor, verktyg) finns i den här databasen
- Kubernetes-klusteråtkomst konfigureras via Talos

## Tips

- Använd `flux get all` för att kontrollera klustersynkstatus
- SOPS-krypterade filer behöver korrekta age-nycklar för att dekrypteras
- Talos-konfiguration är nod-specifik; verifiera målnoden innan du applicerar
