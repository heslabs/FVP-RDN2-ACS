# Utilities


---
### Arm GNU Toolchain Downloads

Arm GNU Toolchain Downloads \
https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads


AArch64 GNU/Linux target (aarch64-none-linux-gnu)

```
arm-gnu-toolchain-14.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
wget https://developer.arm.com/-/media/Files/downloads/gnu/14.3.rel1/binrel/arm-gnu-toolchain-14.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
tar xf arm-gnu-toolchain-14.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
```

---
### Ann 0818

```
./FVP_RD_N2/models/Linux64_GCC-9.3/FVP_RD_N2 --version
 
Fast Models [11.25.23 (Apr 10 2024)]
Copyright 2000-2024 ARM Limited.
All Rights Reserved.
```

```
https://developer.arm.com/Tools%20and%20Software/Fixed%20Virtual%20Platforms/Infrastructure%20FVPs
```

```
i created the ubuntu image by mounting ubuntu iso image + sata image to fvp, and install the OS to sata image which is taking lots lof time. You can try this way to see if it works:
 
dd if=/dev/zero of=ubuntu-minimal.img bs=1M count=20480
LOOP=$(losetup -f --show ubuntu-minimal.img)
parted $LOOP --script mklabel msdos
parted $LOOP --script mkpart primary ext4 1MiB 100%
losetup -d $LOOP
LOOP=$(losetup -f --show -P ubuntu-minimal.img)
mkfs.ext4 ${LOOP}p1
mkdir -p /mnt/ubuntu-minimal
mount ${LOOP}p1 /mnt/ubuntu-minimal
debootstrap jammy /mnt/ubuntu-minimal http://archive.ubuntu.com/ubuntu/
mount -t proc /proc /mnt/ubuntu-minimal/proc
mount -t sysfs /sys /mnt/ubuntu-minimal/sys
mount -o bind /dev /mnt/ubuntu-minimal/dev
chroot /mnt/ubuntu-minimal /bin/bash
apt-get update
apt-get install grub-pc linux-image-generic systemd-sysv -y
grub-install --target=i386-pc --recheck $LOOP
update-grub
exit
umount -R /mnt/ubuntu-minimal
losetup -d $LOOP
 
ubuntu-minimal <---here you are. but I havn't test it, I can give a try after 11am meeting
```

---
最快的方式就是把script改回來再重build…有build過的話，下面這幾個步驟應該1~2分鐘就可以跑完

```
git restore build-target-bins.sh
sudo apt install mtools

./build-scripts/rdinfra/build-test-buildroot.sh -p rdn2 build
./build-scripts/rdinfra/build-test-buildroot.sh -p rdn2 package
```

```
The operation has completed successfully.
Completed preparation of disk image for buildroot boot
```

```
### ./build-scripts/rdinfra/build-test-buildroot.sh
refinfra="rdinfra"
source build-scripts/sgi/build-test-buildroot.sh
source ./build-scripts/sgi/sgi_common_util.sh

CC=${GNU_TARGET}-gcc
CC_ARCH=$($CC -dumpmachine) 
                if [[ $CC_ARCH != *"aarch64"* ]]; then


```

或是只build bios不build buildroot image的話，下面這兩個應該更快

```
./build-scripts/build-test-uefi.sh -p rdn2 build
./build-scripts/build-test-uefi.sh -p rdn2 package
```

從ubuntu disk 開機：

```
export MODEL=<absolute/path/to/FVP/binary>
cd model-scripts/rdinfra
./distro.sh -p rdn2 -d ubuntu.satadisk
```

在uart_ap的console裡一開始會看到可以按esc


---

<img width="600" height="838" alt="image" src="https://github.com/user-attachments/assets/e3d6cc80-7651-4e6e-968a-437bac483e79" />


---
### How to change the default font size of XTerm?
* https://askubuntu.com/questions/161652/how-to-change-the-default-font-size-of-xterm
  
You can add the following as an example to your ```~/.Xresources``` file:

```
! Use a truetype font and size.
xterm*faceName: Monospace
xterm*faceSize: 14
```
Then run the following:
```
xrdb -merge ~/.Xresources
```
