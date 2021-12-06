#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+

################################################################################
## VARIABLES
################################################################################
export COREBOOT_SDK_VERSION="2021-09-23_b0d87f753c"

export DOCKER_ROOT_DIR="/home/coreboot"
export DOCKER_SCRIPT_DIR="$DOCKER_ROOT_DIR/scripts"
export DOCKER_COMMON_SCRIPT_DIR="$DOCKER_ROOT_DIR/common_scripts"
export DOCKER_COREBOOT_DIR="$DOCKER_ROOT_DIR/cb_build"
export DOCKER_COREBOOT_CONFIG_DIR="$DOCKER_COREBOOT_DIR/configs"
export DOCKER_STOCK_BIOS_DIR="$DOCKER_ROOT_DIR/stock_bios/"
