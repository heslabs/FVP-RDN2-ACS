# Setting up the FVP

---
### Installing the software stack

Installing the software stack
Create a folder and change directory to it
```
$ mkdir –p <fvp-rdn2>
$ cd <fvp-rdn2>
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
cd <fvp-rdn2>
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
cd <fvp-rdn2>
mkdir bm_build
cd bm_build
git clone https://github.com/ARM-software/bsa-acs.git
```

Download the Arm GNU Toolchain - AArch64 bare-metal target (aarch64-none-elf)
```
cd <fvp-rdn2>
wget https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-x86_64-aarch64-none-elf.tar.xz
tar -xf arm-gnu-toolchain-13.2.rel1-x86_64-aarch64-none-elf.tar.xz
```


---
### Build the BSA ACS

Build the BSA ACS
```
cd bm_build/bsa-acs/
export CROSS_COMPILE=<fvp-rdn2>/arm-gnu-toolchain-13.2.Rel1-x86_64-aarch64-none-elf/bin/aarch64-none-elf-
mkdir build
cd build/
cmake ../ -G"Unix Makefiles" -DCROSS_COMPILE=$CROSS_COMPILE -DTARGET="RDN2”
make
```

```
-- [ACS] : ACS is set to bsa
-- [ACS] : TARGET is set to RDN2
-- [ACS] : Defaulting ARM_ARCH_MAJOR to 9
-- [ACS] : Defaulting ARM_ARCH_MINOR to 0
-- The ASM compiler identification is GNU
-- Found assembler: /home/demo/labs/infra/fvp-rdn2-2025.07.03/arm-gnu-toolchain-13.2.Rel1-x86_64-aarch64-none-elf/bin/aarch64-none-elf-gcc
-- Configuring done (0.0s)
-- Generating done (0.0s)
-- Build files have been written to: /home/demo/labs/infra/fvp-rdn2-2025.07.03/bm_build/bsa-acs/build
```




```
[ 98%] Generating bsa.elf
/home/demo/labs/infra/fvp-rdn2-2025.07.03/arm-gnu-toolchain-13.2.Rel1-x86_64-aarch64-none-elf/bin/aarch64-none-elf-ld: warning: /home/demo/labs/infra/fvp-rdn2-2025.07.03/bm_build/bsa-acs/build/output//bsa.elf has a LOAD segment with RWX permissions
[ 98%] Built target bsa_elf
[ 99%] Generating bsa.dump
[ 99%] Built target bsa_dump
[ 99%] Generating bsa.bin
[ 99%] Built target bsa_bin
[100%] Generating bsa.img
[100%] Built target bsa_img
```

On a successful build, *.bin, *.elf, .img and debug binaries are generated at build/output directory
Users can override the default settings
```
<fvp-rdn2>/bm_build/bsa-acs/pal/baremetal/target/RDN2/common/include/platform_override_fvp.h
```
For example, the print level

```
* Settings */
#define PLATFORM_OVERRIDE_PRINT_LEVEL  0x3     //The permissible levels are 1,2,3,4 and 5
#define PLATFORM_OVERRIDE_BSA_LEVEL    0x1    // The permissible levels are only 1
```

---
### Baremetal - Running the ACS

Repackage the FIP image with bsa.bin

```
cd <fvp-rdn2>
cp ./bm_build/bsa-acs/build/output/bsa.bin ./output/rdn2/components/css-common/acs_latest.bin
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

#### Build BSA ACS tests
```
./build-scripts/rdinfra/build-test-acs.sh -p rdn2 package
```

### Run the BSA ACS Tests

```
export MODEL=<fvp-rdn2>/FVP_RD_N2/models/Linux64_GCC-9.3/FVP_RD_N2
cd model-scripts/rdinfra/platforms/rdn2
./run_model.sh
```

The logs can be found in <fvp-rd-n2>/rd-infra/model-scripts/rdinfra/platforms/rdn2/rdn2/


---

<img width="2686" height="1596" alt="image" src="https://github.com/user-attachments/assets/41f53fdf-8bfe-4444-8a06-2de136650803" />




---
### UEFI - EDK2 setup and ACS Compilation


#### Download EDK2 and EDK2 port of libc
```
cd <fvp-rdn2>
mkdir uefi_build
cd uefi_build
git clone –recursive –branch edk2-stable202411 https://github.com/tianocore/edk2.git
git clone https://github.com/tianocore/edk2-libc.git edk2/edk2-libc
```

#### Download the Arm GNU Toolchain - AArch64 GNU/Linux target (aarch64-none-linux-gnu)
```
cd <fvp-rdn2>
wget https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
tar –xf arm-gnu-toolchain-13.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
```

#### Build the BSA ACS - UEFI Shell application
```
cd uefi_build/edk2
git submodule update --init --recursive
git clone https://github.com/ARM-software/bsa-acs.git ShellPkg/Application/bsa-acs
git apply ShellPkg/Application/bsa-acs/patches/edk2_bsa_acpi.patch
export GCC49_AARCH64_PREFIX=<fvp-rdn2>/arm-gnu-toolchain-13.2.Rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
export PACKAGES_PATH=<fvp-rdn2>/uefi_build/edk2/edk2-libc/
source edksetup.sh
make -C BaseTools/Source/C
source ShellPkg/Application/bsa-acs/tools/scripts/acsbuild.sh
```

The EFI executable file is generated at Build/Shell/DEBUG_GCC49/AARCH64/Bsa.efi
 
---
### UEFI image creation

Create an image file which contains the 'Bsa.efi' file

```
cd <fvp-rdn2>/uefi_build
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
cd <fvp-rdn2>
## Recover build-scripts/build-target-bins.sh - replace acs_latest.bin with uefi.bin
./build-scripts/rdinfra/build-test-acs.sh -p rdn2 package
export MODEL=<fvp-rdn2>/FVP_RD_N2/models/Linux64_GCC-9.3/FVP_RD_N2
cd model-scripts/rdinfra/platforms/rdn2
./run_model.sh –v ~/systemready_workshop/uefi_build/hda.img
```

```
Select ‘Boot Manager’
Select ’UEFI Shell’
In the UEFI shell, input ’FS2:’
Input ‘Bsa.efi -f acs.txt’
```

#### Get the ACS result
```
sudo mount <fvp-rdn2>/uefi_build/hda.img /mnt/bsa
```
The result is allocated at /mnt/bsa/acs.txt


---

<img width="900" alt="image" src="https://github.com/user-attachments/assets/4871d3ab-07df-424f-afe2-054fb10fd88d" />

---
<img width="600"  alt="image" src="https://github.com/user-attachments/assets/53068ff7-3f85-4f34-9d58-05dcaab534b5" />

---
<img width="600"  alt="image" src="https://github.com/user-attachments/assets/5b00b7c7-6533-4bd5-ac29-f858bce64aa8" />

---
<img width="600" alt="image" src="https://github.com/user-attachments/assets/f504ccf7-0c30-4779-a622-9815c8616b9a" />


---
<img width="600" height="369" alt="image" src="https://github.com/user-attachments/assets/68762870-015e-49c8-9605-f303ee6b0dd6" />

---
<img width="600" height="343" alt="image" src="https://github.com/user-attachments/assets/06f3e5f8-9693-467f-9daf-a02cf95c46f3" />

---
<img width="900" height="759" alt="image" src="https://github.com/user-attachments/assets/294f0758-dbd0-490f-a75b-beb47a8c72e9" />


---

<img width="900" height="707" alt="image" src="https://github.com/user-attachments/assets/1f5b2e1f-b191-44c0-b8ff-21e272218b59" />

---
<img width="900" height="616" alt="image" src="https://github.com/user-attachments/assets/bbbd5bc8-fd80-47fe-9dad-2016c23180df" />

---
<img width="900" height="616" alt="image" src="https://github.com/user-attachments/assets/538c9ea3-10b8-46f5-9727-8788f49e1e67" />


---
### Resource

 
#### Where to get the ACS?
* It is available for download from the following Github repository:
* https://github.com/ARM-software/bsa-acs
* https://github.com/ARM-software/sbsa-acs

#### Version of latest ACS
* BSA ACS: v25.03_REL1.1.0
* SBSA ACS: v25.03_REL7.2.2

#### Compliance requirement for SBSA ACS
* To attain SBSA compliance, it is necessary to execute both BSA and SBSA ACS tests.

#### Which Exception level should the tests run at?
* The SBSA and BSA describe requirements on hardware and obligations on hypervisors and operating systems. Because of this, the ACS is expected to run at Non-secure EL2.

#### What needs to be done  
* https://github.com/ARM-software/sbsa-acs/blob/master/docs/arm_sbsa_architecture_compliance_bare-metal_user_guide.pdf

#### For information on implementing the Exerciser PAL APIs, please refer  
* https://github.com/ARM-software/sbsa-acs/tree/master/docs/PCIe_Exerciser
* https://github.com/ARM-software/sbsa-acs/blob/master/docs/PCIe_Exerciser/Exerciser_API_porting_guide.md




---
refinfra-1615768-uart-0-mcp.log

<img width="600" alt="image" src="https://github.com/user-attachments/assets/168ba22e-6572-4af6-8895-8dc1840fc295" />

---
refinfra-1615768-uart-0-nsec.log

<img width="600"  alt="image" src="https://github.com/user-attachments/assets/ca1d94e7-ae1d-4c9a-855b-124f5a5b8b9b" />

---
refinfra-1615768-uart-0-scp.log

<img width="600" alt="image" src="https://github.com/user-attachments/assets/707ab541-e36b-4065-a413-1cc3d018a786" />

<img width="600" alt="image" src="https://github.com/user-attachments/assets/f9aaf06d-36b7-4dbf-8546-f3a2f03e5cb6" />

<img width="700" alt="image" src="https://github.com/user-attachments/assets/9a4d347a-8a16-4d8b-9406-722ae3d315c8" />

---
refinfra-1615768-uart-0-sec.log

<img width="600" alt="image" src="https://github.com/user-attachments/assets/99ce004e-f5ea-4b02-9134-59fc5497e755" />

<img width="800" alt="image" src="https://github.com/user-attachments/assets/78e6514f-e88f-4385-8e4c-4148d1155872" />

---

<img width="882" height="695" alt="image" src="https://github.com/user-attachments/assets/bcf08f35-e9a0-45f0-98a4-0570d0b46032" />

---
<img width="512" height="735" alt="image" src="https://github.com/user-attachments/assets/523df86e-0445-402e-b912-cb9eb8978c1a" />

---
<img width="1290" height="903" alt="image" src="https://github.com/user-attachments/assets/259543c8-97de-4185-8169-4f97b30a4ce6" />


---
<img width="1032" height="721" alt="image" src="https://github.com/user-attachments/assets/cf5bac0f-52a4-4865-95bb-b0e77354df58" />

---
<img width="1008" height="760" alt="image" src="https://github.com/user-attachments/assets/e1951ef2-bdfd-4b52-ad8d-d4d24914d503" />


---

<img width="1608" height="1319" alt="image" src="https://github.com/user-attachments/assets/5e9425ea-f839-45af-b2ad-2b3bf76d44c6" />
