## heketi-cli

Set heketi-cli
```shell
$ export HEKETI_CLI_SERVER=$(kubectl get svc/heketi --template 'http://{{.spec.clusterIP}}:{{(index .spec.ports 0).port}}')

$ echo $HEKETI_CLI_SERVER
http://10.42.0.0:8080

$ curl $HEKETI_CLI_SERVER/hello
Hello from Heketi
```

Get heketi IP
```shell
kubectl get svc -l glusterfs=heketi-service
NAME      TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
heketi    ClusterIP   10.233.1.76   <none>        8080/TCP   2d
```

Get cluster list
```shell
heketi-cli --server http://10.233.1.76:8080 cluster list
```

Create volume
```shell
root@node01:/home/kube/keycloak/proxy# heketi-cli --server http://10.233.1.76:8080 volume create --size=1
Name: vol_9ed1bce95072035f7839ffd82a7b56b8
Size: 1
Volume Id: 9ed1bce95072035f7839ffd82a7b56b8
Cluster Id: b95fe67f9b397d7c7420400e3f6d658e
Mount: 10.1.168.35:vol_9ed1bce95072035f7839ffd82a7b56b8
Mount Options: backup-volfile-servers=10.1.84.181,10.1.241.99
Block: false
Free Size: 0
Block Volumes: []
Durability Type: replicate
Distributed+Replica: 3

root@node01:/home/kube/keycloak/proxy# heketi-cli --server http://10.233.1.76:8080 topology info

Cluster Id: b95fe67f9b397d7c7420400e3f6d658e

    File:  true
    Block: true

    Volumes:

	Name: heketidbstorage
	Size: 2
	Id: 11dc1779ed0e51b438153f0358907eb1
	Cluster Id: b95fe67f9b397d7c7420400e3f6d658e
	Mount: 10.1.168.35:heketidbstorage
	Mount Options: backup-volfile-servers=10.1.84.181,10.1.241.99
	Durability Type: replicate
	Replica: 3
	Snapshot: Disabled

		Bricks:
			Id: 33b8125f46f36f7677490c2535771d47
			Path: /var/lib/heketi/mounts/vg_165a2f4835e4109e6bf5c3caea5b3d5c/brick_33b8125f46f36f7677490c2535771d47/brick
			Size (GiB): 2
			Node: 0731c257f7f17cd9f714f3e3fd36448c
			Device: 165a2f4835e4109e6bf5c3caea5b3d5c

			Id: e8d4077db7371351330e64185ab63692
			Path: /var/lib/heketi/mounts/vg_bd5c4989abbc43cd0f2913873db6a61b/brick_e8d4077db7371351330e64185ab63692/brick
			Size (GiB): 2
			Node: 8823062c784966a73cfba2ed5bae563e
			Device: bd5c4989abbc43cd0f2913873db6a61b

			Id: f50a610a811e2d94918f8b46c6c7348f
			Path: /var/lib/heketi/mounts/vg_97fe538e547f663213f63444fe164760/brick_f50a610a811e2d94918f8b46c6c7348f/brick
			Size (GiB): 2
			Node: df3eb7b6380b4374e030630494a1873e
			Device: 97fe538e547f663213f63444fe164760


	Name: vol_9b7f3129f32dca85b445d6fa11b93879
	Size: 1
	Id: 9b7f3129f32dca85b445d6fa11b93879
	Cluster Id: b95fe67f9b397d7c7420400e3f6d658e
	Mount: 10.1.168.35:vol_9b7f3129f32dca85b445d6fa11b93879
	Mount Options: backup-volfile-servers=10.1.84.181,10.1.241.99
	Durability Type: replicate
	Replica: 3
	Snapshot: Disabled

		Bricks:
			Id: 1ba71824d10ebaedc2a12bf9628e4d7f
			Path: /var/lib/heketi/mounts/vg_97fe538e547f663213f63444fe164760/brick_1ba71824d10ebaedc2a12bf9628e4d7f/brick
			Size (GiB): 1
			Node: df3eb7b6380b4374e030630494a1873e
			Device: 97fe538e547f663213f63444fe164760

			Id: 8711e62d6d324cd816c3604a3963ec13
			Path: /var/lib/heketi/mounts/vg_165a2f4835e4109e6bf5c3caea5b3d5c/brick_8711e62d6d324cd816c3604a3963ec13/brick
			Size (GiB): 1
			Node: 0731c257f7f17cd9f714f3e3fd36448c
			Device: 165a2f4835e4109e6bf5c3caea5b3d5c

			Id: c2cd6803cc822dc9f52c6595f0b1bed1
			Path: /var/lib/heketi/mounts/vg_bd5c4989abbc43cd0f2913873db6a61b/brick_c2cd6803cc822dc9f52c6595f0b1bed1/brick
			Size (GiB): 1
			Node: 8823062c784966a73cfba2ed5bae563e
			Device: bd5c4989abbc43cd0f2913873db6a61b


	Name: vol_9ed1bce95072035f7839ffd82a7b56b8
	Size: 1
	Id: 9ed1bce95072035f7839ffd82a7b56b8
	Cluster Id: b95fe67f9b397d7c7420400e3f6d658e
	Mount: 10.1.168.35:vol_9ed1bce95072035f7839ffd82a7b56b8
	Mount Options: backup-volfile-servers=10.1.84.181,10.1.241.99
	Durability Type: replicate
	Replica: 3
	Snapshot: Disabled

		Bricks:
			Id: 293a5367b9175d69fc17df40a8fd7637
			Path: /var/lib/heketi/mounts/vg_bd5c4989abbc43cd0f2913873db6a61b/brick_293a5367b9175d69fc17df40a8fd7637/brick
			Size (GiB): 1
			Node: 8823062c784966a73cfba2ed5bae563e
			Device: bd5c4989abbc43cd0f2913873db6a61b

			Id: c3258c999e94d6bf2e3b799ad00f0fe0
			Path: /var/lib/heketi/mounts/vg_97fe538e547f663213f63444fe164760/brick_c3258c999e94d6bf2e3b799ad00f0fe0/brick
			Size (GiB): 1
			Node: df3eb7b6380b4374e030630494a1873e
			Device: 97fe538e547f663213f63444fe164760

			Id: d812738f830406a5772da291d02f11c1
			Path: /var/lib/heketi/mounts/vg_165a2f4835e4109e6bf5c3caea5b3d5c/brick_d812738f830406a5772da291d02f11c1/brick
			Size (GiB): 1
			Node: 0731c257f7f17cd9f714f3e3fd36448c
			Device: 165a2f4835e4109e6bf5c3caea5b3d5c


	Name: vol_abb34cbfdcd0e9dff8eef7909081d2fc
	Size: 8
	Id: abb34cbfdcd0e9dff8eef7909081d2fc
	Cluster Id: b95fe67f9b397d7c7420400e3f6d658e
	Mount: 10.1.168.35:vol_abb34cbfdcd0e9dff8eef7909081d2fc
	Mount Options: backup-volfile-servers=10.1.84.181,10.1.241.99
	Durability Type: replicate
	Replica: 3
	Snapshot: Disabled

		Bricks:
			Id: 6f89e23ac3872acc2a8fa854c407341d
			Path: /var/lib/heketi/mounts/vg_165a2f4835e4109e6bf5c3caea5b3d5c/brick_6f89e23ac3872acc2a8fa854c407341d/brick
			Size (GiB): 8
			Node: 0731c257f7f17cd9f714f3e3fd36448c
			Device: 165a2f4835e4109e6bf5c3caea5b3d5c

			Id: 91b74ab87d9d518c612973fa29eaf474
			Path: /var/lib/heketi/mounts/vg_97fe538e547f663213f63444fe164760/brick_91b74ab87d9d518c612973fa29eaf474/brick
			Size (GiB): 8
			Node: df3eb7b6380b4374e030630494a1873e
			Device: 97fe538e547f663213f63444fe164760

			Id: a276b6e802803e2bbae1f3fd9dbe94ca
			Path: /var/lib/heketi/mounts/vg_bd5c4989abbc43cd0f2913873db6a61b/brick_a276b6e802803e2bbae1f3fd9dbe94ca/brick
			Size (GiB): 8
			Node: 8823062c784966a73cfba2ed5bae563e
			Device: bd5c4989abbc43cd0f2913873db6a61b


    Nodes:

	Node Id: 0731c257f7f17cd9f714f3e3fd36448c
	State: online
	Cluster Id: b95fe67f9b397d7c7420400e3f6d658e
	Zone: 1
	Management Hostnames: node02
	Storage Hostnames: 10.1.168.35
	Devices:
		Id:165a2f4835e4109e6bf5c3caea5b3d5c   Name:/dev/nbd1           State:online    Size (GiB):46      Used (GiB):12      Free (GiB):34      
			Bricks:
				Id:33b8125f46f36f7677490c2535771d47   Size (GiB):2       Path: /var/lib/heketi/mounts/vg_165a2f4835e4109e6bf5c3caea5b3d5c/brick_33b8125f46f36f7677490c2535771d47/brick
				Id:6f89e23ac3872acc2a8fa854c407341d   Size (GiB):8       Path: /var/lib/heketi/mounts/vg_165a2f4835e4109e6bf5c3caea5b3d5c/brick_6f89e23ac3872acc2a8fa854c407341d/brick
				Id:8711e62d6d324cd816c3604a3963ec13   Size (GiB):1       Path: /var/lib/heketi/mounts/vg_165a2f4835e4109e6bf5c3caea5b3d5c/brick_8711e62d6d324cd816c3604a3963ec13/brick
				Id:d812738f830406a5772da291d02f11c1   Size (GiB):1       Path: /var/lib/heketi/mounts/vg_165a2f4835e4109e6bf5c3caea5b3d5c/brick_d812738f830406a5772da291d02f11c1/brick

	Node Id: 8823062c784966a73cfba2ed5bae563e
	State: online
	Cluster Id: b95fe67f9b397d7c7420400e3f6d658e
	Zone: 1
	Management Hostnames: node03
	Storage Hostnames: 10.1.84.181
	Devices:
		Id:bd5c4989abbc43cd0f2913873db6a61b   Name:/dev/nbd1           State:online    Size (GiB):46      Used (GiB):12      Free (GiB):34      
			Bricks:
				Id:293a5367b9175d69fc17df40a8fd7637   Size (GiB):1       Path: /var/lib/heketi/mounts/vg_bd5c4989abbc43cd0f2913873db6a61b/brick_293a5367b9175d69fc17df40a8fd7637/brick
				Id:a276b6e802803e2bbae1f3fd9dbe94ca   Size (GiB):8       Path: /var/lib/heketi/mounts/vg_bd5c4989abbc43cd0f2913873db6a61b/brick_a276b6e802803e2bbae1f3fd9dbe94ca/brick
				Id:c2cd6803cc822dc9f52c6595f0b1bed1   Size (GiB):1       Path: /var/lib/heketi/mounts/vg_bd5c4989abbc43cd0f2913873db6a61b/brick_c2cd6803cc822dc9f52c6595f0b1bed1/brick
				Id:e8d4077db7371351330e64185ab63692   Size (GiB):2       Path: /var/lib/heketi/mounts/vg_bd5c4989abbc43cd0f2913873db6a61b/brick_e8d4077db7371351330e64185ab63692/brick

	Node Id: df3eb7b6380b4374e030630494a1873e
	State: online
	Cluster Id: b95fe67f9b397d7c7420400e3f6d658e
	Zone: 1
	Management Hostnames: node01
	Storage Hostnames: 10.1.241.99
	Devices:
		Id:97fe538e547f663213f63444fe164760   Name:/dev/nbd1           State:online    Size (GiB):46      Used (GiB):12      Free (GiB):34      
			Bricks:
				Id:1ba71824d10ebaedc2a12bf9628e4d7f   Size (GiB):1       Path: /var/lib/heketi/mounts/vg_97fe538e547f663213f63444fe164760/brick_1ba71824d10ebaedc2a12bf9628e4d7f/brick
				Id:91b74ab87d9d518c612973fa29eaf474   Size (GiB):8       Path: /var/lib/heketi/mounts/vg_97fe538e547f663213f63444fe164760/brick_91b74ab87d9d518c612973fa29eaf474/brick
				Id:c3258c999e94d6bf2e3b799ad00f0fe0   Size (GiB):1       Path: /var/lib/heketi/mounts/vg_97fe538e547f663213f63444fe164760/brick_c3258c999e94d6bf2e3b799ad00f0fe0/brick
				Id:f50a610a811e2d94918f8b46c6c7348f   Size (GiB):2       Path: /var/lib/heketi/mounts/vg_97fe538e547f663213f63444fe164760/brick_f50a610a811e2d94918f8b46c6c7348f/brick
```



> https://access.redhat.com/documentation/en-us/red_hat_gluster_storage/3.3/html/container-native_storage_for_openshift_container_platform/chap-documentation-red_hat_gluster_storage_container_native_with_openshift_platform-heketi_cli

```shell
heketi-cli topology info
```
This command retreives information about the current Topology.

```shell
heketi-cli cluster list
```
Lists the clusters managed by Heketi

```shell
heketi-cli cluster info <cluster_id>
```
Retrieves the information about the cluster.

```shell
heketi-cli node info <node_id>
```
Retrieves the information about the node.

```shell
heketi-cli volume list
```
Lists the volumes managed by Heketi


# Volume Path / kubectl PV
```shell
$ kubectl get pv --all-namespaces -o yaml|grep path
mbecker@node01:~$ kubectl get pv --all-namespaces -o yaml|grep path
      path: vol_fc667f0ee612c5586694922f37a16ff4
      path: vol_3229dff053fa34180dd2bc1d119c8e53
          fd = os.open(path, os.O_CREAT | os.O_RDWR)
      path: vol_1b3c335dc952cd6a851b6a95a30e365e
      path: vol_a56e2f1c31cf8a35880754d21362a1cf
      path: vol_fe65329d81e172289eea4aae386c5e4d
````
