# Tipps

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
apt-get update
apt-get install dnsutils
apt-get install curl
nslookup my-nginx
```
