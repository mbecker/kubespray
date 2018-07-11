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
