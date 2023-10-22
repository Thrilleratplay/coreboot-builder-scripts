#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+

# shellcheck disable=SC1091
# LCOV_EXCL_START
if [ -z "$UNIT_TESTING" ]; then
  source /home/coreboot/common_scripts/variables.sh
fi
# LCOV_EXCL_STOP

################################################################################
##
################################################################################
function copyEdk2Bootsplash() {
  if [ ! -e "$DOCKER_COREBOOT_DIR/bootsplash.jpg" ]; then
    cp "$DOCKER_COMMON_SCRIPT_DIR/$EDK2_BOOTSPLASH_JPEG" "$DOCKER_COREBOOT_DIR/bootsplash.jpg" || exit
    echo "Copied EDK2 bootslash.jpg"
  else
    echo "bootsplash.jpg exists.  Skipping."
  fi
}
################################################################################