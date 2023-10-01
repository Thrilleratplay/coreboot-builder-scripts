#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+

# shellcheck disable=SC1091
source /home/coreboot/common_scripts/./variables.sh
source /home/coreboot/common_scripts/./download_coreboot.sh
source /home/coreboot/common_scripts/./config_and_make.sh
source /home/coreboot/common_scripts/./extract_stockbios.sh
source /home/coreboot/common_scripts/./copy_bootsplash.sh

################################################################################
## MODEL VARIABLES
################################################################################
MAINBOARD="lenovo"
MODEL="x220"

################################################################################

###############################################
##   download/git clone/git pull Coreboot    ##
###############################################
downloadOrUpdateCoreboot

##############################################################
##   Export Stock BIOS GBE/ME/IDF (Optional for updating)   ##
##############################################################
# uncomment next line to enable
# extractStockBios "$MAINBOARD" "$MODEL" "stock_bios.bin"

#############################
##   Copy bootsplash.jpg   ##
#############################
copySeaBiosBootsplash

##############################
##   Copy config and make   ##
##############################
configAndMake

#####################
##   Post build    ##
#####################
if [ ! -f "$DOCKER_COREBOOT_DIR/build/coreboot.rom" ]; then
  echo "Uh oh. Things did not go according to plan."
  exit 1;
else
  mv "$DOCKER_COREBOOT_DIR/build/coreboot.rom" "$DOCKER_COREBOOT_DIR/coreboot_$MAINBOARD-$MODEL-complete.rom"
  sha256sum "$DOCKER_COREBOOT_DIR/coreboot_$MAINBOARD-$MODEL-complete.rom" > "$DOCKER_COREBOOT_DIR/coreboot_$MAINBOARD-$MODEL-complete.rom.sha256"
fi
