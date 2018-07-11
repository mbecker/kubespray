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

**Check tht pods from DaemonSet are running**
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
## Create User Credentials / External access with kubectl for specific user

> https://docs.bitnami.com/kubernetes/how-to/configure-rbac-in-your-kubernetes-cluster/#use-case-1-create-user-with-limited-namespace-access

As previously mentioned, Kubernetes does not have API Objects for User Accounts. Of the available ways to manage authentication (see Kubernetes official documentation for a complete list), we will use OpenSSL certificates for their simplicity. The necessary steps are:

### Step 1: Create The Office Namespace
Execute the kubectl create command to create the namespace (as the admin user):
```shell
kubectl create namespace office
```

### Step 2: Create The User Credentials

1.) Create a private key for your user. In this example, we will name the file employee.key:
```shell
openssl genrsa -out employee.key 2048
```

2.) Create a certificate sign request employee.csr using the private key you just created (employee.key in this example). Make sure you specify your username and group in the -subj section (CN is for the username and O for the group). As previously mentioned, we will use employee as the name and bitnami as the group:
```shell
openssl req -new -key employee.key -out employee.csr -subj "/CN=employee/O=bitnami"
```

3.) Locate your Kubernetes cluster certificate authority (CA). This will be responsible for approving the request and generating the necessary certificate to access the cluster API.
The file is located on the master node at "/etc/kubernetes/ssl/ca.pem" and "/etc/kubernetes/ca-key.pem".
Cope th files "ca.pem" and "ca-key.pem" to your local host.
```shell
scp -r ssl root@{MASTER01_EXTERNAL_IP}:/etc/kubernetes/ssl/
```

4.) Generate the final certificate employee.crt by approving the certificate sign request, employee.csr, you made earlier. Make sure you substitute the CA_LOCATION placeholder with the location of your cluster CA. In this example, the certificate will be valid for 500 days:
```shell
openssl x509 -req -in employee.csr -CA /home/mbecker/kube-cluster/kubespray/inventory/kube-cluster/artifacts/ssl/ca.pem -CAkey /home/mbecker/kube-cluster/kubespray/inventory/kube-cluster/artifacts/ssl/ca-key.pem -CAcreateserial -out employee.crt -days 500
```

5.) Save both employee.crt and employee.key in a safe location (in this example we will use /home/employee/.certs/).

6.) Add a new context with the new credentials for your Kubernetes cluster. This example is for a Minikube cluster but it should be similar for others:
```shell
./kubectl --kubeconfig=admin.conf config set-credentials employee --client-certificate=/home/mbecker/kube-cluster/kubespray/inventory/kube-cluster/artifacts/employee/employee.crt --client-key=/home/mbecker/kube-cluster/kubespray/inventory/kube-cluster/artifacts/employee/employee.key

./kubectl --kubeconfig=admin.conf config set-context employee-context --cluster=cluster.local --namespace=office --user=employee
```

7.) Now you should get an access denied error when using the kubectl CLI with this configuration file. This is expected as we have not defined any permitted operations for this user.
```shell
./kubectl --kubeconfig=admin.conf --context=employee-context get pods
```

### Step 3: Create The Role For Managing Deployments
1.) Create a role-deployment-manager.yaml file with the content below. In this yaml file we are creating the rule that allows a user to execute several operations on Deployments, Pods and ReplicaSets (necessary for creating a Deployment), which belong to the core (expressed by "" in the yaml file), apps, and extensions API Groups:
```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  namespace: office
  name: deployment-manager
rules:
- apiGroups: ["", "extensions", "apps"]
  resources: ["deployments", "replicasets", "pods"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"] # You can also use ["*"]
```

2.) Create the Role in the cluster using the kubectl create role command:
```shell
# Use kubectl withd RBAC admin rights
kubectl create -f role-deployment-manager.yaml
```

### Step 4: Bind The Role To The Employee User
1.) Create a rolebinding-deployment-manager.yaml file with the content below. In this file, we are binding the deployment-manager Role to the User Account employee inside the office namespace:
```yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: deployment-manager-binding
  namespace: office
subjects:
- kind: User
  name: employee
  apiGroup: ""
roleRef:
  kind: Role
  name: deployment-manager
  apiGroup: ""
```
or
```shell
>./kubectl --kubeconfig=admin.conf create rolebinding deployment-manager-binding --role=deployment-manager --user=employee
>./kubectl --kubeconfig=admin.conf get rolebinding deployment-manager-binding
NAME                         AGE
deployment-manager-binding   1m
```

2.) Deploy the RoleBinding by running the kubectl create command:
(not necessary if rolebinding was created via 'kubectl create rolebinding')
```shell
> kubectl create -f rolebinding-deployment-manager.yaml
```

### Step 5: Test The RBAC Rule
1.) Now you should be able to execute the following commands without any issues:

```shell
>./kubectl --kubeconfig=admin.conf --context=employee-context run --image bitnami/dokuwiki mydokuwiki
deployment.apps "mydokuwiki" created
>./kubectl --kubeconfig=admin.conf --context=employee-context get pods
NAME                          READY     STATUS    RESTARTS   AGE
mydokuwiki-79d855f98f-mmd29   1/1       Running   0          1m
```

2.) If you run the same command with the --namespace=default argument, it will fail, as the employee user does not have access to this namespace.
```shell
>./kubectl --kubeconfig=admin.conf --context=employee-context get pods --namespace=default
Error from server (Forbidden): pods is forbidden: User "employee" cannot list pods in the namespace "default": role.rbac.authorization.k8s.io "deployment-manager" not found
```
Now you have created a user with limited permissions in your cluster.

**Sample kubectl conf for employee**
```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMrVENDQWVHZ0F3SUJBZ0lKQUxvcTE4UG1yeW1ITUEwR0NTcUdTSWIzRFFFQkN3VUFNQkl4RURBT0JnTlYKQkFNTUIydDFZbVV0WTJFd0lCY05NVGd3TnpFeE1UQXhNVEl6V2hnUE1qRXhPREEyTVRjeE1ERXhNak5hTUJJeApFREFPQmdOVkJBTU1CMnQxWW1VdFkyRXdnZ0VpTUEwR0NTcUdTSWIzRFFFQkFRVUFBNElCRHdBd2dnRUtBb0lCCkFRRE95T2FwR2U4SVU2Y0Y1UGMxUzZFQW9CWGRITE9rdFNhaWpoWCtEK0Y3TFhDMDJrZ3RuOGZYZVhDeTZ4d1IKWWdPVnF2aUxldkQ2dVlpbE5DV2FRM2x1VnJHTkNzbHBtRTNoMmFEN3phTlNXSUVUUGZmY3dzUzdaYm03bVNrSApmQWdTVmVKVjVOdVdTTnNZa3dxMm9tRDdsS2RrQ05tczhXSisyeFQxTEpGRm50ZERNWHpzSW12VXRPd2Jxb3VDCnVFSWVmZXcvdElyMGsySXJoZWFvV3l6bjVCWDlNWXFhOVZVSEpJcUdKenBDSndPZjQzMjVIL1ErbWpBa0g4cWYKZkVqei9TaU01YmJkQzhCQzIvcW1FV1JJSVVBTGNzWE1HT1k5aTdBRlhrYXdwYks4RE1kdmlPZUVmbjFubkNSYwpHZlE1YUNieW5CY3VONG5jbmNYQWNCb2xBZ01CQUFHalVEQk9NQjBHQTFVZERnUVdCQlRMR3hEQXYvdktSYjZJClc0RFVCdWFNc0FwRjl6QWZCZ05WSFNNRUdEQVdnQlRMR3hEQXYvdktSYjZJVzREVUJ1YU1zQXBGOXpBTUJnTlYKSFJNRUJUQURBUUgvTUEwR0NTcUdTSWIzRFFFQkN3VUFBNElCQVFDakZwTVpuZzVkdnE0MWpFeGk4SC9INTNlNQp0L005NzI5bEhqK09jUHQ5Y1AycnVzeXVGY1p2Z0JXL2RrQ2JCLzYvdkVOVGVrWWpwUnhDMTVGOEV6bzk0RTZsCkhYa25KNndZa2QzTS9BK1craTI1UkVwNm5xTEtBSnFINXBTbzJtQmxZbEJHMFRIMlYxTGV2Yk9MVWQxcUc0YmwKRnp5QVM3MlRuS3FxYjBpK012TzlMQ08ya0hmMzBNNzdUbkw2MlpRdlNzYjJ6dG54S3V1N2orOTRwY0g0Qno0UgpTQ2xTU0VUOGcvNEk1czdxMHU2UFBSMXJPYnVtT0RvQjlxSXplK090N2o5QzJwYStVdndiTDY1WUo5YjViM3VPCkFXaTZLMnF6L3J6Q2Jqb3lzRlJsZmpRSzh1ajlnUFllQTZUYm1CQUNLQmFTNE9tdkpYUXIxVjU5ZVBBbwotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    server: https://212.47.241.204:6443
  name: cluster.local
contexts:
- context:
    cluster: cluster.local
    namespace: office
    user: employee
  name: employee-context
current-context: employee-context
kind: Config
preferences: {}
users:
- name: employee
  user:
    client-certificate: employee.crt
    client-key: employee.key
```

## Token for ServiceAccounts / Login at dashboard with token
1.) Create service account
```shell
cat <<EOF | kubectl create -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kube-system
EOFCopy
```

2.) Create ClusterRoleBinding
```shell
cat <<EOF | kubectl create -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kube-system
EOFCopy
```
4.a) Get the Bearer Token. Once you run the following command, copy the token value which you will use on the following step.
```shell
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')Copy
```
4.b) Get the Bearer token locally
```shell
./kubectl --kubeconfig=admin.conf  -n kube-system describe secret $(./kubectl --kubeconfig=admin.conf -n kube-system get secret | grep admin-user | awk '{print $1}') > token_admin-user.txt
```
The file "token_admin-user.txt" looks like:
```shell
Name:         admin-user-token-hddkr
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name=admin-user
              kubernetes.io/service-account.uid=5151d03b-8507-11e8-9300-0007cb03d7b3

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1090 bytes
namespace:  11 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLWhkZGtyIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI1MTUxZDAzYi04NTA3LTExZTgtOTMwMC0wMDA3Y2IwM2Q3YjMiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZS1zeXN0ZW06YWRtaW4tdXNlciJ9.Yc6VFKxTKhcwMUkXEFxvFShW7inf0KxDWp-YfXJO6Z5LRBavOJPtEhyFtP2LJOG72PzfcT2XsDpcnOwoWLQzTL3owLCHojfq0g4O7qZUuG8dlF72hu2CbS9TdDPrblA-asd-boDA
```

5.) Come back to your browser and choose token on the login page. You will need to paste the token value you have copied on the previous step.

![Kubernetes Dashboard Signin with token](http://www.joseluisgomez.com/wp-content/uploads/2018/02/Screen-Shot-2018-02-18-at-15.09.52-300x208.png)

Click “SIGN IN” and you should be able to see your Kubernetes Dashboard fully operational.


