#!/bin/sh

Describe "variables.sh"

  Include "./common/variables.sh"

  It "sets enviromental variables"
    The variable COREBOOT_SDK_VERSION should eq "2023-06-04_44f676afc9"
    The variable DOCKER_ROOT_DIR should eq "/home/coreboot"
    The variable DOCKER_SCRIPT_DIR should eq "$DOCKER_ROOT_DIR/scripts"
    The variable DOCKER_COMMON_SCRIPT_DIR should eq "$DOCKER_ROOT_DIR/common_scripts"
    The variable DOCKER_COREBOOT_DIR should eq "$DOCKER_ROOT_DIR/cb_build"
    The variable DOCKER_COREBOOT_CONFIG_DIR should eq "$DOCKER_COREBOOT_DIR/configs"
    The variable DOCKER_STOCK_BIOS_DIR should eq "$DOCKER_ROOT_DIR/stock_bios/"
  End
End
