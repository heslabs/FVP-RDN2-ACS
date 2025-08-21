# Network

 
#### please follow this to setup TAP interface
* Getting Started — Neoverse Reference Design Platform Software  documentation 
  * https://neoverse-reference-design.docs.arm.com/en/latest/user_guides/getting_started.html#enable-network-for-fvp-s-optional

---

```
sudo ip link set tap0 down
sudo ip link set tap0 nomaster
sudo ip link del tap0
sudo virsh net-destroy default
sudo virsh net-autostart default --disable
sudo ip link set virbr0 down
sudo ip link del virbr0
sudo systemctl disable --now libvirtd
```

```
re-enable
 
sudo systemctl enable --now libvirtd
sudo virsh net-start default
sudo virsh net-autostart default
sudo ip tuntap add dev tap0 mode tap user $(whoami)
sudo ip link set tap0 up
sudo ip link set tap0 master virbr0
```


---
#### Error

```
sudo ip tuntap add dev tap0 mode tap user $(whoami)
ioctl(TUNSETIFF): Device or resource busy
```

```
Error: RD_N2: board.virtio_net.hostbridge: Failed to setup TAP 'tap0'
In file: (unknown):0
```

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

ip link set dev eth0 up
ip link set dev eth0 down

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
#### ubuntu-arm64-server-v821 

```
iomacro_terminal_0: Listening for serial connection on port 5004
iomacro_terminal_1: Listening for serial connection on port 5005
terminal_s0: Listening for serial connection on port 5006
terminal_s1: Listening for serial connection on port 5007
terminal_0: Listening for serial connection on port 5008
terminal_1: Listening for serial connection on port 5009

Info: RD_N2: RD_N2.css.scp.ROMloader: FlashLoader: Loaded 47 kB from file '../../../../output/rdn2/rdn2/scp_romfw.bin'

Info: RD_N2: RD_N2.css.mcp.ROMloader: FlashLoader: Loaded 45 kB from file '../../../../output/rdn2/rdn2/mcp_romfw.bin'

Info: RD_N2: RD_N2.css.trustedBootROMloader: FlashLoader: Loaded 80 kB from file '../../../../output/rdn2/rdn2/tf-bl1.bin'

Info: RD_N2: RD_N2.board.flashloader0: FlashLoader: Loaded 5 MB from file '../../../../output/rdn2/rdn2/fip-uefi.bin'

Info: RD_N2: RD_N2.board.flashloader1: FlashLoader: Loaded 64 MB from file '/home/demo/labs/infra/rdn2/model-scripts/rdinfra/platforms/rdn2/nor1_flash.img'

Info: RD_N2: RD_N2.board.flashloader2: FlashLoader: Loaded 64 MB from file '/home/demo/labs/infra/rdn2/model-scripts/rdinfra/platforms/rdn2/nor2_flash.img'

Warning: RD_N2: RD_N2.css.cmn700: DTC support limited to register model; other capabilities beyond read/write to registers unsupported
In file: (unknown):0
In process: RD_N2.thread_p_128 @ 29406630 ns

Info: RD_N2: board.virtio_net.hostbridge: Reconfigure TAP 'tap0'

```


---
#### ubuntu-satadisck-ann820

<img width="1000" height="1955" alt="image" src="https://github.com/user-attachments/assets/3edc2b7f-fd97-4b43-b715-72cf01c0a5d4" />


