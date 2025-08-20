# Linux Distro Boot
https://neoverse-reference-design.docs.arm.com/en/latest/features/boot/distro_boot.html

* Neoverse Reference Design (RD) platform software stack supports boot of various linux distributions such as Debian, Ubuntu or Fedora.
* This can be achieved either by using a pre-installed (raw) image of the distribution or performing an installation from an iso image.
* The prefered method is to **use the pre-installed images** as greatly reduces the time needed to validate that the software stack can boot into Linux.
* An installation from an iso image can take several hours, and will vary greatly with the hardware used, but even on modern hardware can be around 8 hours.
* Regardless of the approach selected, the common step is to build the software stack as mentioned below in Build the platform software.


---
### Build the platform software

This section describes the procedure to build the platform firmware required to boot or install a linux distribution on Neoverse RD platforms.
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

Debian cloud images page: https://cloud.debian.org/images/cloud/

As an example, to download the image navigate as follows:
```
bookworm/ >> latest >> debian-12-nocloud-arm64.raw
```

Using RD-N2 as an example, set MODEL environment variable to the FVP path, and run the boot script with argument -d to the downloaded image path.
```
export MODEL=<absolute/path/to/FVP/binary>
cd model-scripts/rdinfra && ./distro.sh -p rdn2 -d <absolute/path/to/image>
```

### Example boot script:
```
export MODEL=$(WORKDIR)/FVP_RD_N2/models/Linux64_GCC-9.3/FVP_RD_N2
cd model-scripts/rdinfra && ./distro.sh -p rdn2 -d $(WORKDIR)/images/debian-12-nocloud-arm64-20250804-2194.raw
```


---
<img width="800" height="766" alt="image" src="https://github.com/user-attachments/assets/16efbeef-fd4c-468a-9596-73b0b65a0bb5" />

 
---
### Install a Linux Distribution

After the build of the platform software stack is complete, a distribution can be installed into a SATA disk image. Before beginning the installation process, download the CD iso image of the required distribution version. See below Linux distributions downloads pages:

Linux distributions downloads pages
* Ubuntu: https://ubuntu.com/download/server/arm
* Debian: https://www.debian.org/distrib/netinst
* Fedora: https://alt.fedoraproject.org/alt

---

<img width="800" height="940" alt="image" src="https://github.com/user-attachments/assets/a35b5c86-f7b9-4c22-8851-3ba5e42b5638" />


---

<img width="800" height="700" alt="image" src="https://github.com/user-attachments/assets/07b9e9d8-7bd7-4a3d-8d8b-93596bc60186" />

---

Select an image for the aarch64 architecture. Which can also be named arm64. 
```
### ubuntu-24.04.3-live-server-arm64.iso
wget https://cdimage.ubuntu.com/releases/24.04/release/ubuntu-24.04.3-live-server-arm64.iso?_gl=1*20wu8u*_gcl_au*MTQ5NjY2NzAyMy4xNzU1MDk4MTc5
```

The generic command to perform the installation is:
```
./distro.sh -p <platform name> -i <abs_iso_image_path> -s <disk size> -a <additional_params> -n [true|false]
```

As an example:
```
export MODEL=<absolute/path/to/FVP/binary>
cd model-scripts/rdinfra && ./distro.sh -p rdn2 -i <absolute/path/to/iso> -s 16
```

---

<img width="800" height="940" alt="image" src="https://github.com/user-attachments/assets/41e5293c-cdac-4679-967e-e69bbfb549a6" />


---
### Example boot script
```
export MODEL=$(WORKDIR)/FVP_RD_N2/models/Linux64_GCC-9.3/FVP_RD_N2 
cd model-scripts/rdinfra && ./distro.sh -p rdn2 -i ${WORKDIR}/images/ubuntu-24.04.3-live-server-arm64.iso -s 16
```

```
Login: ubuntu
Password: ubuntu
```

* This command creates a 16GB SATA disk image, boots the selected platform software stack and starts the installation process.
* From here on, follow the instructions of the chosen distribution installer. For more information about the installation procedure, refer online installation manuals of the chosen distribution.
* After the installation is complete, a disk image with a random name <number>.satadisk will be created in ```model-scripts/rdinfra/``` folder. Use this disk image for booting the installed distribution.


---
### Example boot script
```
export MODEL=$(WORKDIR)/FVP_RD_N2/models/Linux64_GCC-9.3/FVP_RD_N2
cd model-scripts/rdinfra && ./distro.sh -p rdn2 -d fedora27.satadisk
```
* Boot from an existing installed disk image

