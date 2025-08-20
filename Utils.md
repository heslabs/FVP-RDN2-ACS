# Utilities

---
### Ann 0818

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
