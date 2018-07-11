# Configuration

### Dashboard - RBAC - Add user

Add user for dashboard / API server access

```yaml
# File: kubespray/inventory/{NAME_OF-INVENTORY}/group_vars/k8s-cluster.yml
# Users to create for basic auth in Kubernetes API via HTTP
# Optionally add groups for user
kube_api_pwd: "{{ lookup('password', inventory_dir + '/credentials/kube_user.creds length=15 chars=ascii_letters,digits') }}"
kube_users:
  kube:
    pass: "{{kube_api_pwd}}"
    role: admin
    groups:
      - system:masters
  {USER_NAME}:
    pass: "{USER_PASSWORD}"
    role: admin
    groups:
      - system:masters
```

### SSL Certificates

Add IPs to SSL certificates
Access with kubectl the external kube api server (for that the ssl certifcates / the certifcate-authority-data in "kubectl config" must be generated for external IP and dns name as well)

```yaml
# File: kubespray/inventory/{NAME_OF-INVENTORY}/group_vars/k8s-cluster.yml
## Supplementary addresses that can be added in kubernetes ssl keys.
## That can be useful for example to setup a keepalived virtual IP
supplementary_addresses_in_ssl_keys: [10.0.0.1, 10.0.0.2, 10.0.0.3, {EXTERNAl_IP_OF_API_SERVER}]
```

### fluentd

Ensure that fluentd is running on all nodes

**1. Run fluentd on all nodes**
```shell
> kubectl label nodes --all beta.kubernetes.io/fluentd-ds-ready=true
```

**2. Run fluentd on specifc nodes**
```shell
# Get nodes
> kubectl get node
NAME      STATUS    ROLES                 AGE       VERSION
node01    Ready     ingress,master,node   28m       v1.10.4
node02    Ready     ingress,node          28m       v1.10.4
node03    Ready     ingress,node          28m       v1.10.4

# Assign label to one specific node
> kubectl label nodes node01 beta.kubernetes.io/fluentd-ds-ready=true
# Or assign label to multiple nodes
> kubectl label nodes node01 node02 node03 beta.kubernetes.io/fluentd-ds-ready=true
```

Check that pods from DaemonSet are running
```shell
> kubectl get pods --namespace=kube-system
NAME                                   READY     STATUS    RESTARTS   AGE
elasticsearch-logging-0                1/1       Running   0          35m
elasticsearch-logging-1                1/1       Running   0          35m
fluentd-es-v2.0.4-6c2wj                1/1       Running   0          9m
fluentd-es-v2.0.4-6lkjz                1/1       Running   0          7m
fluentd-es-v2.0.4-v4f2l                1/1       Running   0          7m
...
```
