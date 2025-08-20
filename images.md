# Create Ubuntu image

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
grub-install --target=arm64-efi --efi-directory=/boot/efi --boot-directory=/boot --removable
update-grub
apt-get install grub-efi-arm64 linux-image-generic -y
update-grub
exit
umount -R /mnt/ubuntu-minimal
losetup -d $LOOP
```


```
mount ${LOOP}p1 /mnt/ubuntu-minimal 
chroot /mnt/ubuntu-minimal /bin/bash
grub-install --target=arm64-efi --efi-directory=/boot/efi --boot-directory=/boot --removable
update-grub
apt-get install grub-efi-arm64 linux-image-generic -y
```

#### Error:

```
root@cx9:/# grub-install --target=i386-pc --recheck $LOOP
Installing for i386-pc platform.
grub-install: error: install device isn't specified.

```
