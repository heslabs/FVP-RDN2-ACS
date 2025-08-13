# Build Busybox

### Busybox Boot
https://neoverse-reference-design.docs.arm.com/en/latest/features/boot/busybox_boot.html

Busybox is a lightweight executable which packages lots of POSIX compliant UNIX utilities in a single file system.

---
### Build the platform software

This section describes the procedure to build the disk image for busybox boot. The disk image consists of two partitions. The first partition is a EFI partition and contains grub. The second partition is a ext3 partition which contains the linux kernel image. Examples on how to use the 
build command for busybox boot are listed below.

To build the software stack, the command to be used is
```
./build-scripts/rdinfra/build-test-busybox.sh -p <platform name> <command>
```

Examples of the build command are

Command to clean, build and package the RD-N2 software stack required for busybox boot on RD-N2 platform:
```
./build-scripts/rdinfra/build-test-busybox.sh -p rdn2 all
```

Command to perform an incremental build of the software components included in the software stack for the RD-N2 platform.
```
./build-scripts/rdinfra/build-test-busybox.sh -p rdn2 build
```

This command should be followed by the package command to complete the preparation of the FIP and the disk image.

Command to package the previously built software stack and prepare the FIP and the disk image.
```
./build-scripts/rdinfra/build-test-busybox.sh -p rdn2 package
```

Log message
```
-------------------------------------
Preparing disk image for busybox boot
-------------------------------------
~/labs/infra/fvp-rdn2/grub/output ~/labs/infra/fvp-rdn2
...
The operation has completed successfully.
Completed preparation of disk image for busybox boot
```

---
### Boot upto Busybox

fter the build of the platform software stack for busybox boot is complete, the following commands can be used to start the execution of the selected platform fastmodel and boot the platform up to the busybox prompt. Examples on how to use the command are listed below.

To boot up to the busybox prompt, the commands to be used are

Set MODEL path before launching the model:
```
export MODEL=<absolute path to the platform FVP binary>
```

Command to start the execution of the RD-N2 model to boot up to the Busybox prompt with network enabled. The model supports virtio.net allowing the software running within the model to access the network:
```
cd model-scripts/rdinfra
./boot.sh -p <platform name> -a <additional_params> -n [true|false]
./boot.sh -p rdn2 -n true
```
