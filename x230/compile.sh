#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+
source "/home/coreboot/common_scripts/variables.sh"
source "/home/coreboot/common_scripts/download_coreboot.sh"

################################################################################
## MODEL VARIABLES
################################################################################
MAINBOARD="lenovo"
MODEL="x230"

################################################################################
#
downloadOrUpdateCoreboot

# Copy config
if [ ! -f "$DOCKER_COREBOOT_DIR/.config" ]; then
  if [ -f "$DOCKER_SCRIPT_DIR/config-$COREBOOT_COMMIT" ]; then
    cp "$DOCKER_SCRIPT_DIR/config-$COREBOOT_COMMIT" "$DOCKER_COREBOOT_DIR/.config"
  elif [ -f "$DOCKER_SCRIPT_DIR/config-$COREBOOT_TAG" ]; then
    cp "$DOCKER_SCRIPT_DIR/config-$COREBOOT_TAG" "$DOCKER_COREBOOT_DIR/.config"
  else
    cp "$DOCKER_SCRIPT_DIR/config" "$DOCKER_COREBOOT_DIR/.config"
  fi
fi

cd "$DOCKER_COREBOOT_DIR" || exit;

### make
if [ $COREBOOT_CONFIG ]; then
  make nconfig
fi

make

if [ ! -f "$DOCKER_COREBOOT_DIR/build/coreboot.rom" ]; then
  echo "Uh oh. Things did not go according to plan."
  exit 1;
else
  mv "$DOCKER_COREBOOT_DIR/build/coreboot.rom" "$DOCKER_COREBOOT_DIR/coreboot_$MAINBOARD-$MODEL-full.rom"

  #split out top BIOS
  dd if="$DOCKER_COREBOOT_DIR/coreboot_$MAINBOARD-$MODEL-full.rom" of="$DOCKER_COREBOOT_DIR/coreboot_$MAINBOARD-$MODEL-top.rom" bs=1M skip=8

  sha256sum "$DOCKER_COREBOOT_DIR/coreboot_$MAINBOARD-$MODEL-full.rom" > "$DOCKER_COREBOOT_DIR/coreboot_$MAINBOARD-$MODEL-full.rom.sha256"
  sha256sum "$DOCKER_COREBOOT_DIR/coreboot_$MAINBOARD-$MODEL-top.rom" > "$DOCKER_COREBOOT_DIR/coreboot_$MAINBOARD-$MODEL-top.rom-sha256"
fi
