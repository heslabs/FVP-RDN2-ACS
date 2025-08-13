# Setting up the FVP

---
### Installing the software stack

Installing the software stack
Create a folder and change directory to it
```
$ mkdir –p ~/ systemready_workshop/rd-infra
$ cd ~/systemready_workshop /rd-infra
```

Please tell me who you are.
```
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

Initialize and sync the source code
```
$ sudo apt install repo
$ repo init -u https://git.gitlab.arm.com/infra-solutions/reference-design/infra-refdesign-manifests.git -m pinned-rdn2.xml -b refs/tags/RD-INFRA-2025.02.04 --depth=1
$ repo sync -c -j $(nproc) --fetch-submodules --force-sync --no-clone-bundle
```

* infra-refdesign-manifests
   * https://git.gitlab.arm.com/infra-solutions/reference-design/infra-refdesign-manifests

```
$ sudo apt install repo
$ repo init -u https://git.gitlab.arm.com/infra-solutions/reference-design/infra-refdesign-manifests.git -m pinned-rdn2.xml -b refs/tags/RD-INFRA-2025.07.03 --depth=1
$ repo sync -c -j $(nproc) --fetch-submodules --force-sync --no-clone-bundle
```

---

The RD N2 software stack integrates multiple software components

<img width="818" height="627" alt="image" src="https://github.com/user-attachments/assets/51ce3c5e-2992-4e49-b272-688b81e74e76" />

---
### Set up the build environment

Set up the build environment before building the software stack

#### Using Host Environment
Installing prerequisite on your Linux host

```
$ ./build-scripts/rdinfra/install_prerequisites.sh
```

#### Using Docker to get your environment clean
Build the docker image
```
$ ./container-scripts/container.sh build
```

Successfully tagged rdinfra-builder:latest \
Start the container with the rd-infra folder mounted.
```
$ ./container-scripts/container.sh run -v ~/rd-infra
```

---
### Downloading the Reference Model – RD N2

Download the latest version of RD N2 FVP
```
wget https://developer.arm.com/-/media/Arm%20Developer%20Community/Downloads/OSS/FVP/Neoverse-N2/FVP_RD_N2_11.25_23_Linux64.tgz
```

```
wget https://developer.arm.com/-/cdn-downloads/permalink/FVPs-Neoverse-Infrastructure/RD-N2/FVP_RD_N2_11.25_23_Linux64.tgz
```

FVP Release page: Infrastructure FVPs  
```
https://developer.arm.com/Tools%20and%20Software/Fixed%20Virtual%20Platforms/Infrastructure%20FVPs 
```

Setup the Reference Model – RD N2
Unzip the model package
```
tar xvf FVP_RD_N2_11.25_23_Linux64.tgz
```

Install the RD N2 FVP
```
./FVP_RD_N2.sh
```

The default installation path is ~/FVP_RD_N2
```
Installing to '/home/demo/labs/infra/neocss_fvp/FVP_RD_N2' (This may take a while...)
Installation completed successfully
```

---
### Building the software stack
Modify the number of interrupts
```
cd ~/systemready_workshop/rd-infra
```

Modify the following in uefi/edk2/ArmPkg/Drivers/ArmGic/GicV3/ArmGicV3Dxe.c
```
- mGicNumInterrupts = ArmGicGetMaxNumInterrupts (mGicDistributorBase);
+ mGicNumInterrupts = 16384;
```


Build the software stack
```
./build-scripts/rdinfra/build-test-acs.sh -p rdn2 all
```

---
### Setting the PCIe hierarchy 
Download the pre-customized PCIe hierarchy file
```
wget https://github.com/ARM-software/bsa-acs/blob/main/docs/PCIe_Exerciser/example_pcie_hierarchy_0.json
```

To run the BSA exerciser tests make the following change in ~/systemready_workshop/rd-infra /model-scripts/rdinfra/platforms/rdn2/run_model.sh
```
- -C pcie_group_0.pciex16.hierarchy_file_name=<default> \
- -C pcie_group_1.pciex16.hierarchy_file_name="example_pcie_hierarchy_2.json" \ 
- -C pcie_group_2.pciex16.hierarchy_file_name="example_pcie_hierarchy_3.json" \ 
- -C pcie_group_3.pciex16.hierarchy_file_name="example_pcie_hierarchy_4.json" \ 
+ -C pcie_group_0.pciex16.hierarchy_file_name="example_pcie_hierarchy_0.json" \
```

---
### Baremetal - ACS Compilation


Download the BSA ACS
```
cd ~/systemready_workshop
mkdir bm_build
cd bm_build
git clone https://github.com/ARM-software/bsa-acs.git
```

Download the Arm GNU Toolchain - AArch64 bare-metal target (aarch64-none-elf)
```
cd ~/systemready_workshop
wget https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-x86_64-aarch64-none-elf.tar.xz
tar -xf arm-gnu-toolchain-13.2.rel1-x86_64-aarch64-none-elf.tar.xz
```


---
### Build the BSA ACS

Build the BSA ACS
```
cd bm_build/bsa-acs/
export CROSS_COMPILE=~/systemready_workshop/arm-gnu-toolchain-13.2.Rel1-x86_64-aarch64-none-elf/bin/aarch64-none-elf-
mkdir build
cd build/
cmake ../ -G"Unix Makefiles" -DCROSS_COMPILE=$CROSS_COMPILE -DTARGET="RDN2”
make
```

On a successful build, *.bin, *.elf, .img and debug binaries are generated at build/output directory
Users can override the default settings
```
~/systemready_workshop/bm_build/bsa-acs/pal/baremetal/target/RDN2/common/include/platform_override_fvp.h
```
For example, the print level


---
### Baremetal - Running the ACS

Repackage the FIP image with bsa.bin
```
cp output/bsa.bin ~/systemready_workshop/rd-infra/output/rdn2/components/css-common/acs_latest.bin
cd ~/systemready_workshop/rd-infra/
```

In build-scripts/build-target-bins.sh, replace uefi.bin with acs_latest.bin:
```
 if [ "${!tfa_tbbr_enabled}" == "1" ]; then
      $TOP_DIR/$TF_A_PATH/tools/cert_create/cert_create  \
      ${cert_tool_param} \
-     ${bl33_param_id} ${OUTDIR}/${!uefi_out}/uefi.bin
+     ${bl33_param_id} ${OUTDIR}/${!uefi_out}/acs_latest.bin
  fi
  ${fip_tool} update \
  ${fip_param} \
- ${bl33_param_id} ${OUTDIR}/${!uefi_out}/uefi.bin \
+ ${bl33_param_id} ${OUTDIR}/${!uefi_out}/acs_latest.bin \
  ${PLATDIR}/${!target_name}/fip-uefi.bin
```

 
```
./build-scripts/rdinfra/build-test-acs.sh -p rdn2 package
```

Run the BSA ACS
```
cd model-scripts/rdinfra/platforms/rdn2
export MODEL=~/systemready_workshop/FVP_RD_N2/models/Linux64_GCC-9.3/FVP_RD_N2
./run_model.sh
```

The logs can be found in ~/systemready_workshop/rd-infra/model-scripts/rdinfra/platforms/rdn2/rdn2/

 
---
### UEFI - EDK2 setup and ACS Compilation

Download EDK2 and EDK2 port of libc
```
cd ~/systemready_workshop
mkdir uefi_build
cd uefi_build
git clone –recursive –branch edk2-stable202411 https://github.com/tianocore/edk2.git
git clone https://github.com/tianocore/edk2-libc.git edk2/edk2-libc
```

Download the Arm GNU Toolchain - AArch64 GNU/Linux target (aarch64-none-linux-gnu)
```
cd ~/systemready_workshop
wget https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
tar –xf arm-gnu-toolchain-13.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
```

Build the BSA ACS - UEFI Shell application
```
cd uefi_build/edk2
git submodule update --init --recursive
git clone https://github.com/ARM-software/bsa-acs.git ShellPkg/Application/bsa-acs
git apply ShellPkg/Application/bsa-acs/patches/edk2_bsa_acpi.patch
export GCC49_AARCH64_PREFIX=~/systemready_workshop/arm-gnu-toolchain-13.2.Rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
export PACKAGES_PATH=~/systemready_workshop/uefi_build/edk2/edk2-libc/
source edksetup.sh
make -C BaseTools/Source/C
source ShellPkg/Application/bsa-acs/tools/scripts/acsbuild.sh
```

The EFI executable file is generated at Build/Shell/DEBUG_GCC49/AARCH64/Bsa.efi

---
### UEFI - Image creation

Create an image file which contains the 'Bsa.efi' file
```
cd ~/systemready_workshop/uefi_build
mkfs.vfat -C -n HD0 hda.img 2097152
sudo mkdir /mnt/bsa
sudo mount hda.img /mnt/bsa
sudo cp edk2/Build/Shell/DEBUG_GCC49/AARCH64/Bsa.efi /mnt/bsa/
sudo umount /mnt/bsa
```

---
### UEFI - Running the ACS

Run the BSA ACS
```
cd ~/systemready_workshop/rd-infra/
```

Recover build-scripts/build-target-bins.sh - replace acs_latest.bin with uefi.bin
```
./build-scripts/rdinfra/build-test-acs.sh -p rdn2 package
export MODEL=~/systemready_workshop/FVP_RD_N2/models/Linux64_GCC-9.3/FVP_RD_N2
cd model-scripts/rdinfra/platforms/rdn2
./run_model.sh –v ~/systemready_workshop/uefi_build/hda.img
```

```
Select ‘Boot Manager’
Select ’UEFI Shell’
In the UEFI shell, input ’FS2:’
Input ‘Bsa.efi –f acs.txt’
```

Get the ACS result
```
sudo mount ~/systemready_workshop/uefi_build/hda.img /mnt/bsa
```
The result is allocated at /mnt/bsa/acs.txt

---
### UEFI - Running the ACS







