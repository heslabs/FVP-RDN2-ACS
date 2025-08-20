# Utilities

---
### Ann 0818

最快的方式就是把script改回來再重build…有build過的話，下面這幾個步驟應該1~2分鐘就可以跑完

git restore build-target-bins.sh
./build-scripts/rdinfra/build-test-buildroot.sh -p rdn2 build
./build-scripts/rdinfra/build-test-buildroot.sh -p rdn2 package

或是只build bios不build buildroot image的話，下面這兩個應該更快

./build-scripts/build-test-uefi.sh -p rdn2 build
./build-scripts/build-test-uefi.sh -p rdn2 package


從ubuntu disk 開機：

export MODEL=<absolute/path/to/FVP/binary>
cd model-scripts/rdinfra
./distro.sh -p rdn2 -d ubuntu.satadisk

在uart_ap的console裡一開始會看到可以按esc


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
