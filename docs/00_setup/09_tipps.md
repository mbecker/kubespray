# Tipps

## Kubernetes Configuration
```shell
# Edit manifest in /etc/kubernetes/manifests
-rw-r--r-- 1 root root 3817 Jul 20 06:26 kube-apiserver.manifest
-rw-r--r-- 1 root root 2414 Jul 14 12:13 kube-controller-manager.manifest
-rw-r--r-- 1 root root 2030 Jul 14 12:11 kube-proxy.manifest
-rw-r--r-- 1 root root 1653 Jul 14 12:12 kube-scheduler.manifest

# Normally Kubernetes should restart the docker container; if not then restart kubelet
sudo systemctl stop kubelet
sudo rm -rf /var/lib/kubelet/pods/*
sudo systemctl start kubelet
```

## exec to pods
```shell
kubectl exec -it fluentd-k2dt2  -- /bin/bash
```

## Run busybox as container to test DNS names

Start a busybox container and connect to it's bash. Then check if a DNS name within that POD could be rsolved.

```shell
$ kubectl run curl --image=radial/busyboxplus:curl -i --tty
```

Waiting for pod default/curl-131556218-9fnch to be running, status is Pending, pod ready: false
Hit enter for command prompt
Then, hit enter and run nslookup my-nginx:
```shell
[ root@curl-131556218-9fnch:/ ]$ nslookup my-nginx
Server:    10.0.0.10
Address 1: 10.0.0.10

Name:      my-nginx
Address 1: 10.0.162.149
```
## Debian: Install nslookup
```shell
apt-get update -y && apt-get install dnsutils -y && apt-get install curl -y
nslookup my-nginx
```
