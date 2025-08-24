# RDV3

* Arm Ecosystem FVPs
    * https://developer.arm.com/Tools%20and%20Software/Fixed%20Virtual%20Platforms#Downloads
* Arm Ecosystem FVP - Infrastructure FVPs
    * https://developer.arm.com/Tools%20and%20Software/Fixed%20Virtual%20Platforms/Infrastructure%20FVPs
* Neoverse V3 Reference Design FVP
    * https://developer.arm.com/Tools%20and%20Software/Fixed%20Virtual%20Platforms/Infrastructure%20FVPs
* FVP_RD_V3_11.29_35_Linux64.tgz
    * https://developer.arm.com/-/cdn-downloads/permalink/FVPs-Neoverse-Infrastructure/RD-V3/FVP_RD_V3_11.29_35_Linux64.tgz
* FVP_RD_V3_11.29_35_Linux64_armv8l.tgz
    * https://developer.arm.com/-/cdn-downloads/permalink/FVPs-Neoverse-Infrastructure/RD-V3/FVP_RD_V3_11.29_35_Linux64_armv8l.tgz

---
### Platform Software

* Neoverse Reference Design Platform Software
  * https://neoverse-reference-design.docs.arm.com/en/latest/index.html
* RD-V3 Platform Software
  * https://neoverse-reference-design.docs.arm.com/en/latest/platforms/rdv3.html
* Distro Boot (and Install)
   * https://neoverse-reference-design.docs.arm.com/en/latest/features/boot/distro_boot.html#distro-boot


---
### Getting Started

* Getting Started
   * https://neoverse-reference-design.docs.arm.com/en/latest/user_guides/getting_started.html#prerequisites
* Platform Manifest Names: pinned-rdv3.xml
   * https://neoverse-reference-design.docs.arm.com/en/latest/shared/platform_manifests.html#platform-manifests


---
#### Download Sources

```
repo init -u https://git.gitlab.arm.com/infra-solutions/reference-design/infra-refdesign-manifests.git -m <manifest-file-name> -b refs/tags/<RELEASE_TAG> --depth=1
repo init -u https://git.gitlab.arm.com/infra-solutions/reference-design/infra-refdesign-manifests.git -m pinned-rdv3.xml -b refs/tags/RD-INFRA-2025.07.03 --depth=1
repo sync -c -j $(nproc) --fetch-submodules --force-sync --no-clone-bundle
```

---
#### Download FVP

```
wget https://developer.arm.com/-/cdn-downloads/permalink/FVPs-Neoverse-Infrastructure/RD-V3/FVP_RD_V3_11.29_35_Linux64.tgz
tar zxvf RD-V3/FVP_RD_V3_11.29_35_Linux64.tgz
./FVP_RD_V3.sh
Where would you like to install to? [default: /home/demo/FVP_RD_V3] /home/demo/labs/infra/rdv3/FVP_RD_V3
```


---
#### Install Container Engine

* https://neoverse-reference-design.docs.arm.com/en/latest/user_guides/getting_started.html#prerequisites

```
./container.sh build -i rdv3
./container.sh -v /absolute/path/to/rd-infra run
export WORKDIR=${PWD}
./container.sh -v ${WORKDIR) -i rdv3 run
```

```
demo@cx9:~/labs/infra/rdv3/container-scripts$ ./container.sh -h
Usage: ./container.sh [OPTIONS] [COMMAND]
```

---
#### Distro Boot (and Install)

* https://neoverse-reference-design.docs.arm.com/en/latest/features/boot/distro_boot.html#distro-boot
  
```
./build-scripts/build-test-uefi.sh -p rdv3 clean
./build-scripts/build-test-uefi.sh -p rdv3 build
./build-scripts/build-test-uefi.sh -p rdv3 package
```

```
export MODEL=<absolute/path/to/FVP/binary>
cd model-scripts/rdinfra
./distro.sh -p rdv3 -d <absolute/path/to/image>
```

---
#### Boot a Linux Distribution

```
export MODEL=${WORKDIR}/FVP_RD_V3
cd model-scripts/rdinfra
./distro.sh -p rdv3 -d ${WORKDIR}/../ubuntu.satadisk.rdv3
```

```
model-scripts/sgi/distro.sh
```

---
#### Error

```
Info: RD_V3: RD_V3.css.ap_periph.ns_uart1 uart fifo capacity set as 32
libEGL warning: DRI3: failed to query the version
libEGL warning: DRI2: failed to authenticate
X Error of failed request:  BadRequest (invalid request code or no such operation)
```

```
Incorrect X11 Forwarding Configuration:
Server-side: Ensure X11Forwarding yes is present in /etc/ssh/sshd_config on the remote server and the SSH daemon is restarted.
Client-side: Ensure ForwardX11 yes (and optionally ForwardX11Trusted yes) is present in ~/.ssh/config or /etc/ssh/ssh_config on the local machine.
Connecting: When initiating the SSH connection, use the -X (or -Y for trusted forwarding) flag:
```

```
## container-scripts/container.sh

docker run --rm \
        ${PARAMS} \
        --network host \
        --env="DISPLAY" \
        --env DISPLAY=:1 \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        ${ARCADE} \
        -t \
        -i \
        ${IMAGE_NAME}
```


```
demo@cx9:~/labs/infra/rdv3$  glxinfo
name of display: localhost:13.0
display: localhost:13  screen: 0
direct rendering: Yes
server glx vendor string: SGI
server glx version string: 1.4
```

```
demo@cx9:~/labs/infra/rdv3$ glxinfo | grep -i yes
direct rendering: Yes
    Unified memory: yes
```


