# Network

 
#### please follow this to setup TAP interface
* Getting Started — Neoverse Reference Design Platform Software  documentation 
  * https://neoverse-reference-design.docs.arm.com/en/latest/user_guides/getting_started.html#enable-network-for-fvp-s-optional


---
#### Launch script

```
./distro.sh -p rdn2 -d ${WORKDIR}/../images/ubuntu.satadisk -n true -a "--parameter board.virtio_net.transport=modern --parameter disable_visualisation=true"
```

```
Error: RD_N2: board.virtio_net.hostbridge: Failed to setup TAP 'lo'
```

* Configuring networks
  * https://documentation.ubuntu.com/server/explanation/networking/configuring-networks/


```
ip a
sudo lshw -class network
sudo ethtool eth0
sudo ip addr add 192.168.52.101/24 dev eth0

ip link set dev eth0 up
ip link set dev eth0 down

ip address show dev eth0

sudo ip route add default via 10.102.66.1

ip route show

ip addr flush eth0

sudo netplan apply
ip address show lo

/etc/resolv.conf -> ../run/systemd/resolve/stub-resolv.conf
```

---
### Debug


---
<img width="1000" height="1955" alt="image" src="https://github.com/user-attachments/assets/3edc2b7f-fd97-4b43-b715-72cf01c0a5d4" />


