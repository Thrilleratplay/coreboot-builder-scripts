#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+

# shellcheck disable=SC1091
# LCOV_EXCL_START
if [ -z "$UNIT_TESTING" ]; then
  source /home/coreboot/common_scripts/variables.sh
fi
# LCOV_EXCL_STOP

IFD_TOOL_PATH="util/ifdtool";

#######################
##   build ifdtool   ##
#######################
function buildIfdtool() {
  if [ ! -f "$DOCKER_COREBOOT_DIR/$IFD_TOOL_PATH/ifdtool" ]; then
    # Make ifdtool
    cd "$DOCKER_COREBOOT_DIR/$IFD_TOOL_PATH" || exit
    make
    chmod +x ifdtool || exit
  fi
}
################################################################################

###################################################################################
##   Extract Intel ME firmware, Gigabit Ethernet firmware and flash descriptor   ##
###################################################################################
function extractStockBios() {
  MAINBOARD=$1 || null
  MODEL=$2 || null
  STOCK_BIOS_ROM=$3 || null

  if [ -z "$MAINBOARD" ]; then
    echo "extractStockBios is missing the MAINBOARD, MODEL and STOCK_BIOS_ROM parameters." >&2
    exit 1;
  fi

  if [ -z "$MODEL" ]; then
    echo "extractStockBios is missing the MODEL and STOCK_BIOS_ROM parameters." >&2
    exit 1;
  fi

    if [ -z "$STOCK_BIOS_ROM" ]; then
    echo "extractStockBios is missing the STOCK_BIOS_ROM parameter." >&2
    exit 1;
  fi

  if [ ! -f "$DOCKER_STOCK_BIOS_DIR/$STOCK_BIOS_ROM" ]; then
    echo "Cannot find $STOCK_BIOS_ROM." >&2
    exit 1;
  fi

  buildIfdtool

  if [ ! -d "$DOCKER_COREBOOT_DIR/3rdparty/blobs/mainboard/$MAINBOARD/$MODEL/" ]; then
    mkdir -p "$DOCKER_COREBOOT_DIR/3rdparty/blobs/mainboard/$MAINBOARD/$MODEL/" || exit
  fi

  if [ ! -f "$DOCKER_COREBOOT_DIR/3rdparty/blobs/mainboard/$MAINBOARD/$MODEL/gbe.bin" ]; then
    cd "$DOCKER_COREBOOT_DIR/3rdparty/blobs/mainboard/$MAINBOARD/$MODEL/" || exit

    cp "$DOCKER_COREBOOT_DIR/$IFD_TOOL_PATH/ifdtool" . || exit

    # ALWAYS COPY THE ORIGINAL.  Never modified the original stock bios file
    cp "$DOCKER_STOCK_BIOS_DIR/$STOCK_BIOS_ROM" . || exit

    # unlock, extract blobs and rename
    sh ifdtool -u "$STOCK_BIOS_ROM" || exit
    sh ifdtool -x "$STOCK_BIOS_ROM" || exit
    mv flashregion_0_flashdescriptor.bin descriptor.bin
    mv flashregion_2_intel_me.bin me.bin
    mv flashregion_3_gbe.bin gbe.bin

    # clean up
    rm ifdtool
    rm flashregion_1_bios.bin
  fi
}
################################################################################
