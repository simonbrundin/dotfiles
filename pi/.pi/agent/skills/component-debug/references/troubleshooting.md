# Component Debug Reference

Detaljerade felsökningssteg per komponent.

## Flux

### Source Problem

```bash
# 1. Beskriv gitrepository
kubectl describe gitrepository flux-system -n flux-system

# 2. Kolla artifact
kubectl get gitrepository flux-system -n flux-system -o jsonpath='{.status.artifact}'

# 3. Loggar
flux logs --kind=GitRepository --name=flux-system

# 4. Verifiera SSH
ssh -T git@github.com

# 5. Rekonciliera
flux reconcile source git flux-system -n flux-system --force
```

### Kustomization Problem

```bash
# 1. Dependency tree
flux tree kustomization flux -n flux-system

# 2. Status
kubectl get kustomization flux -n flux-system -o yaml

# 3. Rekonciliera
flux reconcile kustomization flux -n flux-system --with-source

# 4. Events
kubectl events -n flux-system | grep -i error
```

### HelmRelease Problem

```bash
# 1. Beskriv helmrelease
kubectl describe helmrelease <name> -n <namespace>

# 2. History
kubectl get helmrelease <name> -n <namespace> -o jsonpath='{.status.history}'

# 3. Loggar
kubectl logs -n flux-system -l app=helm-controller --tail=100

# 4. Source
kubectl describe ocirepository <name> -n flux-system
```

## Longhorn

### Volume Problem

```bash
# 1. Lista volymer
kubectl get volumes -n longhorn-system

# 2. Volume details
kubectl describe volume <name> -n longhorn-system

# 3. Nodes
kubectl get nodes.longhorn.io -n longhorn-system

# 4. Replicas
kubectl get replicas.longhorn.io -n longhorn-system

# 5. Disk status
kubectl get drivervolume -n longhorn-system
```

### Volume Restore

```bash
# 1. Skapa VolumeRestore CR
cat <<EOF | kubectl apply -f -
apiVersion: longhorn.io/v1beta2
kind: VolumeRestore
metadata:
  name: restore-<volume>
  namespace: longhorn-system
spec:
  volume:
    name: <volume>
  restorationSource:
    backupTarget: default
    backupVolume: <backup-volume>
    backupName: <backup-name>
EOF

# 2. Monitoring
kubectl get volumes.restore.longhorn.io -n longhorn-system -w
```

### Degraded Volume Fix

```bash
# 1. Identifiera problem
kubectl describe volume <name> -n longhorn-system

# 2. Kolla replicas
kubectl get replicas.longhorn.io -n longhorn-system | grep <volume>

# 3. Reparera
simon kubernetes longhorn repair

# 4. Vänta på återställning
kubectl get volumes -n longhorn-system -w
```

## cert-manager

### Certificate Problem

```bash
# 1. Certificate status
kubectl get certificates -A -o wide

# 2. Certificate details
kubectl describe certificate <name> -n <namespace>

# 3. Issuer/ClusterIssuer
kubectl get clusterissuers -A
kubectl describe clusterissuer <name>

# 4. Orders (if ACME)
kubectl get orders -A

# 5. Challenges (if ACME)
kubectl get challenges -A
```

### DNS-01 Challenge

```bash
# 1. Challenge details
kubectl describe challenge <name> -n <namespace>

# 2. Secret
kubectl get secret <challenge-secret> -n <namespace>

# 3. Loggar
kubectl logs -n cert-manager -l app=cert-manager --tail=100

# 4. Solver config
kubectl get clusterissuer <name> -o yaml | yq '.spec.acme.dns01'
```

### HTTP-01 Challenge

```bash
# 1. Pod för cert-manager-http
kubectl get pods -n cert-manager

# 2. Ingress route
kubectl get httpchallenge -A

# 3. Testa manuellt
curl -I http://<domain>/.well-known/acme-challenge/<token>
```

## CloudNativePG

### Cluster Problem

```bash
# 1. Cluster status
kubectl get clusters.postgresql.cnpg.io -A -o wide

# 2. Pods
kubectl get pods -n <namespace> -l 'cnpg.io/cluster'

# 3. Logs
kubectl logs <primary-pod> -n <namespace>

# 4. PostgreSQL status
kubectl exec -n <namespace> <primary-pod> -- psql -c "SELECT * FROM pg_stat_replication;"
```

### Backup Problem

```bash
# 1. Backup status
kubectl get backups.postgresql.cnpg.io -A

# 2. Backup details
kubectl describe backup <name> -n <namespace>

# 3. Barman secrets
kubectl get secret barman-secret-<cluster> -n <namespace>

# 4. Backup config
kubectl get cluster <cluster> -n <namespace> -o jsonpath='{.spec.backups}'
```

### Pooler Problem

```bash
# 1. Pooler status
kubectl get poolers.postgresql.cnpg.io -A

# 2. Pooler config
kubectl describe pooler <name> -n <namespace>

# 3. Connection pooling
kubectl exec -n <namespace> <pooler-pod> -- psql -c "SELECT * FROM pg_stat_activity;"
```

## Metallb

### IP Allocation Problem

```bash
# 1. IPAddressPools
kubectl get ipaddresspools.metallb.io -A

# 2. L2Advertisements
kubectl get l2advertisements.metallb.io -A

# 3. IPs
kubectl get ipaddressclaims.metallb.io -A

# 4. Speakers
kubectl get pods -n metallb-system

# 5. Speaker logs
kubectl logs -n metallb-system -l app=metallb-speaker --tail=100
```

### Speaker Problem

```bash
# 1. Pod status
kubectl get pods -n metallb-system -l app=metallb-speaker

# 2. Interface config
kubectl exec -n metallb-system <pod> -- ip addr

# 3. BGP sessions
kubectl exec -n metallb-system <pod> -- frrctl show bgp sum

# 4. L2 announcements
kubectl exec -n metallb-system <pod> -- ip link show
```

## Vault

### Vault Sealed

```bash
# 1. Pod status
kubectl get pods -n vault

# 2. Vault status
kubectl exec -n vault <pod> -- vault status

# 3. Raft members
kubectl exec -n vault <pod> -- vault operator raft peers

# 4. Unseal
kubectl exec -n vault <pod> -- vault operator unseal <unseal-key>
```

### Vault Raft Problem

```bash
# 1. Raft status
kubectl exec -n vault <pod> -- vault operator raft status

# 2. Health
kubectl exec -n vault <pod> -- curl -s http://localhost:8200/v1/sys/health

# 3. Loggar
kubectl logs -n vault <pod> --tail=200
```

## External Secrets (ESO)

### ExternalSecret Failed

```bash
# 1. ExternalSecret status
kubectl get externalsecrets -A -o wide

# 2. ExternalSecret details
kubectl describe externalsecret <name> -n <namespace>

# 3. SecretStore
kubectl get secretstores -A
kubectl describe secretstore <name>

# 4. ClusterSecretStore
kubectl get clustersecretstores -A

# 5. Controller logs
kubectl logs -n external-secrets -l app.kubernetes.io/name=external-secrets --tail=100
```

### ClusterExternalSecret

```bash
# 1. Status
kubectl get clusterexternalsecret -A -o wide

# 2. Secrets created
kubectl get secrets | grep <prefix>

# 3. Namespace selector
kubectl get namespace -l <label>
```

## Kyverno

### PolicyReport Problem

```bash
# 1. PolicyReports
kubectl get policyreports -A

# 2. ClusterPolicyReports
kubectl get clusterpolicyreports -A

# 3. Policy status
kubectl get clusterpolicies -A

# 4. Generate reports
kubectl logs -n kyverno -l app=kyverno --tail=100
```

### Policy Enforcement

```bash
# 1. Policy violations
kubectl get policyreports -A -o json | jq '.items[].status.fail'

# 2. Validate policy
kubectl describe clusterpolicy <name>

# 3. Enforce/audit mode
kubectl get clusterpolicy <name> -o jsonpath='{.spec.rules}'
```

## Kube Prometheus Stack

### Prometheus Problem

```bash
# 1. Prometheus pods
kubectl get pods -n monitoring -l app=prometheus

# 2. Prometheus status
kubectl exec -n monitoring <prometheus-pod> -- promtool check config /etc/prometheus/prometheus.yml

# 3. Targets
kubectl exec -n monitoring <prometheus-pod> -- wget -qO- localhost:9090/api/v1/targets

# 4. Rules
kubectl get prometheusrules -A
```

### Alertmanager Problem

```bash
# 1. Alertmanager pods
kubectl get pods -n monitoring -l app=alertmanager

# 2. Config
kubectl get alertmanager main -n monitoring -o yaml

# 3. Status
kubectl exec -n monitoring <alertmanager-pod> -- amtool --alertmanager.url=http://localhost:9093 api status
```

## Kubelet CSR Approver

### CSR Not Approved

```bash
# 1. Pending CSRs
kubectl get csr | grep Pending

# 2. CSR details
kubectl describe csr <name>

# 3. Approver logs
kubectl logs -n kubelet-csr-approver <pod> --tail=100

# 4. Approver config
kubectl get deployment kubelet-csr-approver -n kubelet-csr-approver -o yaml
```

### Manual CSR Approval

```bash
# 1. Lista alla
kubectl get csr

# 2. Godkänn
kubectl certificate approve <csr-name>

# 3. Eller med pattern
kubectl get csr -o name | xargs -I {} kubectl certificate approve {}
```