# SBSA ACS Linux Kernel Module

To enable the export of a few kernel APIs that are necessary for PCIe and SMMU tests, Linux kernel module and a kernel patch file are required. These files are available at linux-acs.

---
### System Architecture Compliance Suite - Linux Kernel module
* https://gitlab.arm.com/linux-arm/linux-acs

The steps required to build and run SBSA ACS Linux Tests can be found as part of the SBSA ACS README file.
* https://github.com/ARM-software/sbsa-acs/blob/master/README.md


---
### FF-A ACS - Linux Kernel Module
* https://gitlab.arm.com/linux-arm/linux-acs/-/blob/master/ffa-acs-drv/README.md

This document provides information on executing ff-a-acs tests from the Linux application. This needs Linux kernel module files to load FF-A ACS Test VM1 endpoint code at kernel level and run as part of Linux kernel. These files are hosted under ffa-acs-drv directory. The procedure to build and run FF-A tests with Linux is described here.
