#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+

# shellcheck disable=SC1091
# LCOV_EXCL_START
if [ -z "$UNIT_TESTING" ]; then
  source /home/coreboot/common_scripts/variables.sh
fi
# LCOV_EXCL_STOP

################################################################################
## Copy config and run make
################################################################################
function configAndMake() {

  cd "$DOCKER_COREBOOT_DIR" || exit;

  ######################
  ##   Copy config   ##
  ######################
  if [ -f "$DOCKER_COREBOOT_DIR/.config" ]; then
    echo "Using existing config"

    # clean config to regenerate
    make savedefconfig

    if [ -e "$DOCKER_COREBOOT_DIR/defconfig" ]; then
      mv "$DOCKER_COREBOOT_DIR/defconfig" "$DOCKER_COREBOOT_CONFIG_DIR/"
    fi
  else
    if [ -f "$DOCKER_SCRIPT_DIR/defconfig-$COREBOOT_COMMIT" ]; then
      cp "$DOCKER_SCRIPT_DIR/defconfig-$COREBOOT_COMMIT" "$DOCKER_COREBOOT_CONFIG_DIR/defconfig"
      echo "Using config-$COREBOOT_COMMIT"
    elif [ -f "$DOCKER_SCRIPT_DIR/defconfig-$COREBOOT_TAG" ]; then
      cp "$DOCKER_SCRIPT_DIR/defconfig-$COREBOOT_TAG" "$DOCKER_COREBOOT_CONFIG_DIR/defconfig"
      echo "Using config-$COREBOOT_TAG"
    else
      cp "$DOCKER_SCRIPT_DIR/defconfig" "$DOCKER_COREBOOT_CONFIG_DIR/defconfig"
      echo "Using default config"
    fi
  fi

  ################
  ##  Config   ##
  ###############
  make defconfig

  if [ "$COREBOOT_CONFIG" ]; then
    make nconfig
  fi

  ##############
  ##   make   ##
  ##############
  make
}
