#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+
source "/home/coreboot/common_scripts/variables.sh"
source "/home/coreboot/common_scripts/download_coreboot.sh"


echo "The build currently display black screen during boot.  Exiting"
exit 1;

################################################################################
## MODEL VARIABLES
################################################################################
MAINBOARD="lenovo"
MODEL="x220"

STOCK_BIOS_ROM="stock_bios.bin"

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

if [ ! -f "$DOCKER_COREBOOT_DIR/util/ifdtool/ifdtool" ]; then
  # Make ifdtool
  cd "$DOCKER_COREBOOT_DIR/util/ifdtool" || exit
  make
  chmod +x ifdtool || exit
fi

if [ ! -d "$DOCKER_COREBOOT_DIR/3rdparty/blobs/mainboard/$MAINBOARD/$MODEL/" ]; then
  mkdir -p "$DOCKER_COREBOOT_DIR/3rdparty/blobs/mainboard/$MAINBOARD/$MODEL/"
fi


if [ ! -f "$DOCKER_COREBOOT_DIR/3rdparty/blobs/mainboard/$MAINBOARD/$MODEL/gbe.bin" ]; then
  cd "$DOCKER_COREBOOT_DIR/3rdparty/blobs/mainboard/$MAINBOARD/$MODEL/" || exit

  cp "$DOCKER_COREBOOT_DIR/util/ifdtool/ifdtool" .
  cp "$DOCKER_SCRIPT_DIR/stock_bios/$STOCK_BIOS_ROM" .

  # unlock, extract blobs and rename
  ./ifdtool -u "$STOCK_BIOS_ROM" || exit
  ./ifdtool -x "$STOCK_BIOS_ROM" || exit
  mv flashregion_0_flashdescriptor.bin descriptor.bin
  mv flashregion_2_intel_me.bin me.bin
  mv flashregion_3_gbe.bin gbe.bin

  # clean up
  rm ifdtool
  rm flashregion_1_bios.bin
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
  mv "$DOCKER_COREBOOT_DIR/build/coreboot.rom" "$DOCKER_COREBOOT_DIR/coreboot_$MAINBOARD-$MODEL-complete.rom"
  sha256sum "$DOCKER_COREBOOT_DIR/coreboot_$MAINBOARD-$MODEL-complete.rom" > "$DOCKER_COREBOOT_DIR/coreboot_$MAINBOARD-$MODEL-complete.rom.sha256"
fi
