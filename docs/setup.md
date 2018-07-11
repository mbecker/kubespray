## Configuration
### SSL Certificates
> Add IPs to SSL certificates
> Access with kubectl the external kube api server (for that the ssl certifcates / the certifcate-authority-data in "kubectl config" must be generated for external IP and dns name as well)

**File: kubespray/inventory/{NAME_OF-INVENTORY}/group_vars/k8s-cluster.yml**
```yaml
## Supplementary addresses that can be added in kubernetes ssl keys.
## That can be useful for example to setup a keepalived virtual IP
supplementary_addresses_in_ssl_keys: [10.0.0.1, 10.0.0.2, 10.0.0.3, {EXTERNAl_IP_OF_API_SERVER}]
```
