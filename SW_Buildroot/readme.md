# Buildroot Boot
https://neoverse-reference-design.docs.arm.com/en/latest/features/boot/buildroot_boot.html

Buildroot is a simple, efficient and easy-to-use tool to generate a complete Linux systems through cross-compilation. In order to achieve this, buildroot is able to generate a cross-compilation toolchain, a root filesystem, a Linux kernel image and a bootloader for a target and can be used for any combination, independently, one can for example use an existing cross- compilation toolchain, and build only the root filesystem with buildroot.

Online documentation for buildroot can be found here.
* https://buildroot.org/docs.html

Buildroot boot on Neoverse Reference Design platforms allows the use of buildroot as the filesystem and boot the software stack on the fast model. This document describes the procedure to build and execute the software stack with buildroot as the root filesystem

---
### Build the platform software

This section describes the procedure to build the disk image for buildroot boot. The disk image consists of two partitions. The first partition is a EFI partition and contains grub. The second partition is a ext3 partition and contains the linux kernel image. Examples on how to use the build command for buildroot boot are listed below.

To build the software stack, the command to be used is
```
./build-scripts/rdinfra/build-test-buildroot.sh -p <platform name> <command>
```

Examples of the build command are \
Command to clean, build and package the software stack needed for the buildroot boot on RD-N2 platform:
```
./build-scripts/rdinfra/build-test-buildroot.sh -p rdn2 all
```

---
### Modifying buildroot target filesystem (optional)

Buildroot supports a number of pre-configured packages, customizations across various components, supports a number of pre-configured packages, and also allows adding or modifying files on the target filesystem. This provides the ability to create a richer filesystem compared to busybox.

Though not recommended, for temporary modifications, it is possible to modify the buildroot target filesystem directly and rebuild the image. The target file- system is available under out/arm64/target/ directory in buildroot source. After making required changes, build the software stack again to rebuild the target filesystem image.

After the changes are made, run the build command for buildroot and package it. Examples of the incremental build command are \
Command to perform an incremental build of the buildroot component included in the software stack for the RD-N2 platform.
```
./build-scripts/build-buildroot.sh -p rdn2 build
```

Command to package the previously built software stack and prepares the FIP and the disk image.
```
./build-scripts/rdinfra/build-test-buildroot.sh -p rdn2 package
```

---
### Booting with Buildroot as the filesystem

After the build of the platform software stack for buildroot boot is complete, the following command starts the execution of the selected platform fastmodel and the software boots up to the buildroot prompt. Examples on how to use the command are listed below.

To boot up to the buildroot prompt, the command to be used is \
Set MODEL path before launching the model:
```
export MODEL=<absolute path to the platform FVP binary>
```
 
Launch buildroot boot:
```
cd model-scripts/rdinfra
./boot-buildroot.sh -p <platform name> -a <additional_params> -n [true|false]
```

Example commands to boot with buildroot as the filesystem are as listed below. \
Command to start the execution of the RD-N2 model to boot up to the buildroot prompt:
```
./boot-buildroot.sh -p rdn2
```

Command to start the execution of the RD-N2 model to boot up to the buildroot prompt with network enabled. The model supports virtio.net allowing the software running within the model to access the network:
```
./boot-buildroot.sh -p rdn2 -n true
```

Command to start the execution of the RD-N2 model with networking enabled and to boot up to the buildroot prompt. Additional parameters to the model are supplied using the -a command line parameter:
```
./boot-buildroot.sh -p rdn2 -n true -a "-C board.flash0.diagnostics=1"
```
