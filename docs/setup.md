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

2.) Deploy the RoleBinding by running the kubectl create command:
```shell
kubectl create -f rolebinding-deployment-manager.yaml
```


