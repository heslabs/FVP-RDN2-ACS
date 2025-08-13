# Distro Boot
https://neoverse-reference-design.docs.arm.com/en/latest/features/boot/distro_boot.html

* Neoverse Reference Design (RD) platform software stack supports boot of various linux distributions such as Debian, Ubuntu or Fedora.
* This can be achieved either by using a pre-installed (raw) image of the distribution or performing an installation from an iso image.
* The prefered method is to use the pre-installed images as greatly reduces the time needed to validate that the software stack can boot into Linux.
* An installation from an iso image can take several hours, and will vary greatly with the hardware used, but even on modern hardware can be around 8 hours.
* Regardless of the approach selected, the common step is to build the software stack as mentioned below in Build the platform software.


---
### Build the platform software

This section describes the procedure to build the platform firmware required to boot or install a linux distribution on Neoverse RD platforms. \
To build the RD software stack, the command to be used is
```
./build-scripts/build-test-uefi.sh -p <platform name> <command>
```

Using RD-N2 as an example: \
Command to clean, build and package the software stack:
```
./build-scripts/build-test-uefi.sh -p rdn2 all
```

Command to remove the generated outputs (binaries):
```
./build-scripts/build-test-uefi.sh -p rdn2 clean
```

If using incremental builds, use target command build followed by package, so the output binaries are correctly generated. \
Command to perform an incremental build of the software stack:
```
./build-scripts/build-test-uefi.sh -p rdn2 build
./build-scripts/build-test-uefi.sh -p rdn2 package
```

---
### Boot a Linux Distribution - Pre-Installed (Raw) images

The cloud images for Debian can be obtained from the Debian cloud images page. A number of images listed by codename, along with the daily builds of the latest release version are available on this page.


As an example, to download the image navigate as follows:
```
bookworm/ >> latest >> debian-12-nocloud-arm64.raw
```

Using RD-N2 as an example, set MODEL environment variable to the FVP path, and run the boot script with argument -d to the downloaded image path.
```
export MODEL=<absolute/path/to/FVP/binary>
cd model-scripts/rdinfra
./distro.sh -p rdn2 -d <absolute/path/to/image>
```

---
### Install a Linux Distribution

After the build of the platform software stack is complete, a distribution can be installed into a SATA disk image. Before beginning the installation process, download the CD iso image of the required distribution version. See below Linux distributions downloads pages:

Select an image for the aarch64 architecture. Which can also be named arm64. \
The generic command to perform the installation is:
```
./distro.sh -p <platform name> -i <abs_iso_image_path> -s <disk size> -a <additional_params> -n [true|false]
```

As an example:
```
export MODEL=<absolute/path/to/FVP/binary>
cd model-scripts/rdinfra
./distro.sh -p rdn2 -i <absolute/path/to/iso> -s 16
```

* This command creates a 16GB SATA disk image, boots the selected platform software stack and starts the installation process.
* From here on, follow the instructions of the chosen distribution installer. For more information about the installation procedure, refer online installation manuals of the chosen distribution.
* After the installation is complete, a disk image with a random name <number>.satadisk will be created in model-scripts/rdinfra/ folder. Use this disk image for booting the installed distribution.


