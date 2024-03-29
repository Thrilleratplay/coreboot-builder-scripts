#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+

################################################################################
## VARIABLES
################################################################################
export COREBOOT_SDK_VERSION="2023-06-04_44f676afc9"

export DOCKER_ROOT_DIR="/home/coreboot"
export DOCKER_SCRIPT_DIR="$DOCKER_ROOT_DIR/scripts"
export DOCKER_COMMON_SCRIPT_DIR="$DOCKER_ROOT_DIR/common_scripts"
export DOCKER_COREBOOT_DIR="$DOCKER_ROOT_DIR/cb_build"
export DOCKER_COREBOOT_CONFIG_DIR="$DOCKER_COREBOOT_DIR/configs"
export DOCKER_STOCK_BIOS_DIR="$DOCKER_ROOT_DIR/stock_bios/"

export SEABIOS_BOOTSPLASH_JPEG="bootsplash_esc_menu_1024x768.jpg"
