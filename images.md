# Create Ubuntu image

---
### ubuntu-satadisk-ann821

---
<img width="1200" height="1259" alt="image" src="https://github.com/user-attachments/assets/dc8afe25-254d-4ea7-8afc-f2ea7ea319fd" />

---
<img width="1200" height="1259" alt="image" src="https://github.com/user-attachments/assets/c06edcc3-a808-4fc7-b690-47eb59ecd10f" />

---
<img width="1200" height="2100" alt="image" src="https://github.com/user-attachments/assets/d35aa84b-5595-44e8-841b-64289a301ca6" />


---
#### ubuntu-arm64-efi.img

```
Info: RD_N2: board.virtio_net.hostbridge: Reconfigure TAP 'tap0'
```

<img width="600" height="766" alt="image" src="https://github.com/user-attachments/assets/fba8bdcf-3e83-48aa-ab39-e1c6ea87ef1b" />


---
#### ubuntu-arm64-server.img

<img width="600" height="766" alt="image" src="https://github.com/user-attachments/assets/59881558-15f4-486b-a936-05152ae37518" />

<img width="600" height="766" alt="image" src="https://github.com/user-attachments/assets/ffa3460b-9bd1-4495-9a15-5e88e2968a58" />

---
#### ubuntu-arm64-server.img

<img width="600" height="766" alt="image" src="https://github.com/user-attachments/assets/f62e0cdd-891a-4ee0-8e56-ddd52d48df8d" />

```
dd if=/dev/zero of=ubuntu-minimal.img bs=1M count=20480
LOOP=$(sudo losetup -f --show ubuntu-minimal.img)
sudo parted $LOOP --script mklabel msdos
sudo parted $LOOP --script mkpart primary ext4 1MiB 100%
sudo losetup -d $LOOP
LOOP=$(sudo losetup -f --show -P ubuntu-minimal.img)
sudo mkfs.ext4 ${LOOP}p1
sudo mkdir -p /mnt/ubuntu-minimal
sudo mount ${LOOP}p1 /mnt/ubuntu-minimal
sudo apt install debootstrap
sudo debootstrap jammy /mnt/ubuntu-minimal http://archive.ubuntu.com/ubuntu/
sudo mount -t proc /proc /mnt/ubuntu-minimal/proc
sudo mount -t sysfs /sys /mnt/ubuntu-minimal/sys
sudo mount -o bind /dev /mnt/ubuntu-minimal/dev
sudo chroot /mnt/ubuntu-minimal /bin/bash
apt-get update
apt-get install grub-pc linux-image-generic systemd-sysv -y
## grub-install --target=i386-pc --recheck $LOOP
grub-install --target=i386-pc --efi-directory=/boot/efi --boot-directory=/boot --removable
grub-install --target=arm64-efi --efi-directory=/boot/efi --boot-directory=/boot --removable
update-grub
apt-get install grub-efi-arm64 linux-image-generic -y
update-grub
exit
umount -R /mnt/ubuntu-minimal
losetup -d $LOOP
```

---
#### Solution:

```
mount ${LOOP}p1 /mnt/ubuntu-minimal 
chroot /mnt/ubuntu-minimal /bin/bash
grub-install --target=arm64-efi --efi-directory=/boot/efi --boot-directory=/boot --removable
update-grub
apt-get install grub-efi-arm64 linux-image-generic -y
```

---
#### Error:
```
root@cx9:/# grub-install --target=arm64-efi --efi-directory=/boot/efi --boot-directory=/boot --removable
grub-install: error: /usr/lib/grub/arm64-efi/modinfo.sh doesn't exist. Please specify --target or --directory.
root@cx9:/# 
```

#### Error:

```
root@cx9:/# grub-install --target=i386-pc --recheck $LOOP
Installing for i386-pc platform.
grub-install: error: install device isn't specified.

```
