#!/bin/bash


```
ROOT_DIR=$(pwd)
WORKSPACE="rd-infra"
WORKSPACE_PATH=$ROOT_DIR/$WORKSPACE
export MODEL=/home/demo/labs/infra/infra_fvp_ann/FVP_RD_N2/models/Linux64_GCC-9.3/FVP_RD_N2
export DISTRO=ubuntu

cd $WORKSPACE_PATH/model-scripts/rdinfra
./distro.sh -p rdn2 -d $ROOT_DIR/ubuntu.satadisk -n true -a "--parameter board.virtio_net.transport=modern --parameter disable_visualisation=true"
```
