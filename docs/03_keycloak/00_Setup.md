# Setup
- Install helm (should already be installed)
- Initialize helm (helm init)
- Create values.yaml [Github Repo stable/keycloak](https://github.com/helm/charts/blob/master/stable/keycloak/values.yaml)
- Install keycloak with values.yaml
```shell
helm install --name keycloak -f values.yaml --namespace=iam stable/keycloak
```
