# 1.) Add repository
# ansible kube-master -a "add-apt-repository ppa:gluster/glusterfs-4.1" -u root -i ./hosts.ini

# 2.) Update repository list
# ansible kube-master -a "apt-get update" -u root -i ./hosts.ini

# 3.) Install package
# ansible kube-master -a "apt-get install -y glusterfs-client" -u root -i ./hosts.ini

# 4.) Enable kernel modules
# ansible kube-all -m shell -a "modprobe dm_snapshot && modprobe dm_mirror && modprobe dm_thin_pool && lsmod | grep dm_" -u root -i ./hosts.ini 

# x.) Delete / Remove dirs / logs to re-initialize gluster fs kubernetes
ansible kube-all -m shell -a "rm -rf /var/lib/heketi /etc/glusterfs /var/lib/glusterd /var/log/glusterfs && wipefs -a /dev/nbd1" -u root -i ./hosts.ini