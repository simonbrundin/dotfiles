---
name: cluster-debug
description: >
  Felsök Kubernetes-klusterhälsa med `simon cluster health`. Utlösare: "felsök
  kluster", "kluster health", "kubernetes health", "cluster health check",
  "kluster-status", "simon cluster health". Inkluderar Flux, Longhorn, Vault,
  ESO, CNPG, Talos-hälsokontroller och vanliga Kubernetes-fel.
---

# Kubernetes Cluster Health Debug Skill

Felsök Kubernetes-kluster med fokus på `simon cluster health` kommandot.

## När Använda Denna Skill

Denna skill triggas vid alla felsökningsförfrågningar relaterade till:

- `simon cluster health` kommandot
- Kubernetes-kluster status och hälsa
- Flux GitOps-synkronisering
- Longhorn storage-problem
- Vault secrets-hantering
- External Secrets Operator (ESO)
- CloudNativePG databaser
- Talos-nodhälsa
- CSR-godkännande

## Snabb Felsökning

### Kör hela cluster health

````bash
# Kör fullständig hälsokontroll
simon cluster health


### Snabba Kontroller

```bash
# Flux status
flux get all -A

# Longhorn volymer
kubectl get volumes -n longhorn-system
kubectl get nodes.longhorn.io -n longhorn-system

# Vault status
kubectl exec -n vault <vault-pod> -- vault status

# CNPG databaser
kubectl get clusters.postgresql.cnpg.io -A
kubectl get backups.postgresql.cnpg.io -A

# ESO ExternalSecrets
kubectl get externalsecrets -A

# Pending CSR
kubectl get csr | grep Pending
````

## Vanliga Problem och Åtgärder

| Symptom                            | Diagnos                                      | Åtgärd                                                               |
| ---------------------------------- | -------------------------------------------- | -------------------------------------------------------------------- |
| `simon cluster health` hänger      | Ping-fel eller Talos timeout                 | Kontrollera nätverk och noder                                        |
| Flux Kustomization inte Reconciled | `flux get kustomizations`                    | Kör `flux reconcile` eller kolla logs                                |
| Longhorn volymer degraded/faulted  | `kubectl get volumes -n longhorn-system`     | Reparera med `simon kubernetes longhorn repair`                      |
| Vault sealed                       | `vault status`                               | Kör `vault unseal` på drabbade noder                                 |
| ESO ExternalSecret Failed          | `kubectl get externalsecrets -A`             | Verifiera ESO-konfiguration och SecretStore                          |
| CNPG cluster not ready             | `kubectl get clusters.postgresql.cnpg.io -A` | Kolla poddar och logs i cnpg-system                                  |
| Pending CSR                        | `kubectl get csr \| grep Pending`            | Kör `simon kubernetes approve csr` ör `simon kubernetes approve csr` |

## `simon cluster health` Komponenter

Kommandot kontrollerar följande i ordning:

### 1. Verktygskontroll

Kontrollerar att `ping`, `talosctl`, `kubectl`, `yq` är installerade.

### 2. Nod-ping

Ping till alla controlplane- och worker-noder via IP från

`~/repos/infrastructure/talos/nodes.yaml`.

### 3. Talos health

```bash

talosctl health --nodes <controlplane-ip>
```

### 4. Kubernetes noder

```bash
kubectl get nodes
```

### 5. Flux controllers

```bash
kubectl get pods -n flux-system
```

### 6. Flux Kustomizations

```bash
flux get kustomizations -A
```

### 7. Flux Sources (OCI, Helm, Git)

```bash
flux get sources oci -A
flux get sources helm -A
flux get sources git -A

```

### 8. HelmReleases

```bash

flux get helmreleases -A
```

### 9. Pending CSR

```bash

kubectl get csr | grep Pending
```

### 10. Kubelet CSR Approver

```bash
kubectl get deployment kubelet-csr-approver -n kubelet-csr-approver
kubectl get pods -n kubelet-csr-approver
```

### 11. Longhorn

- Volymer (healthy, degraded, faulted, attached, detached)
- Nod-diskstatus (schedulable/unschedulable)

### 12. Vault

- Poddar i vault namespace
- Unsealed status
- Health endpoint
- Secret-läsning

### 13. ESO (External Secrets Operator)

- ExternalSecrets status
- ClusterExternalSecret
- ClusterSecretStore

### 14. CNPG (CloudNativePG)

- PostgreSQL clusters
- Backups
- Poolers

## Felsöknings-kommandon

### Flux Problem

```bash
# Rekonciliera en Kustomization
flux reconcile kustomization <name> -n <namespace>

# Rekonciliera en Source
flux reconcile source git <name> -n <namespace>

# Visa Flux-logg
flux logs --kind=Kustomization --name=<name>

# Force refresh
flux reconcile source <type>/<name> --force
```

### Longhorn Problem

```bash
# Reparera Longhorn
simon kubernetes longhorn repair

# Longhorn Dashboard
simon kubernetes longhorn test

# Kontrollera volume-attachment
kubectl get volumes -n longhorn-system -o wide

# Node-disk status
kubectl get nodes.longhorn.io -n longhorn-system -o yaml
```

### Vault Problem

```bash
# Vault status
kubectl exec -n vault <pod> -- vault status

# Unseal en pod
kubectl exec -n vault <pod> -- vault operator unseal <unseal-key>

# VAULT_TOKEN via CSI
kubectl get secret vault-secrets -n <namespace>
```

### CSR Problem

```bash
# Lista alla CSR
kubectl get csr

# Godkänn en CSR
kubectl certificate approve <csr-name>

# Auto-godkännande via kubelet-csr-approver
kubectl get deployment kubelet-csr-approver -n kubelet-csr-approver
```

### ESO Problem

```bash
# ExternalSecrets status
kubectl get externalsecrets -A -o wide

# ClusterExternalSecret
kubectl get clusterexternalsecret -A

# SecretStore
kubectl get secretstores -A

# Controller logs
kubectl logs -n external-secrets -l app.kubernetes.io/name=external-secrets
```

## Konfigurationsfiler

```
~/repos/infrastructure/
├── talos/
│   └── nodes.yaml          # Nod-IP och roller
├── infrastructure-flux/    # Flux-konfiguration
│   ├── apps/
│   ├── components/
│   └── clusters/
└── manifests/
    ├── infrastructure/    # Operators
    └── applications/       # Applikationer
```

