#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+

# shellcheck disable=SC1091
# LCOV_EXCL_START
if [ -z "$UNIT_TESTING" ]; then
  source /home/coreboot/common_scripts/variables.sh
fi
# LCOV_EXCL_STOP

################################################################################
### NOTE: assumes coreboot has already been downloaded
################################################################################


UTIL_CHROMEOS_PATH="$DOCKER_COREBOOT_DIR/util/chromeos"

################################################################################
## Download and compile "uudecode" as it is not included in the coreboot-sdk docker image
################################################################################
function downloadUudecode() {
  wget https://ftp.gnu.org/gnu/sharutils/sharutils-4.15.2.tar.xz
  tar xJf sharutils-4.15.2.tar.xz
  cd sharutils-4.15.2 || exit
  sed -i 's/BUFSIZ/rw_base_size/' src/unshar.c
  sed -i '/program_name/s/^/extern /' src/*opts.h
  sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
  echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h
  ./configure
  make
  mv src/uudecode "$UTIL_CHROMEOS_PATH" || exit
}

################################################################################
## Download and compile "parted" as it is not included in the coreboot-sdk docker image
################################################################################
function downloadParted() {
  wget https://ftp.gnu.org/gnu/parted/parted-3.4.tar.xz
  tar xJf parted-3.4.tar.xz
  cd parted-3.4 || exit
  ./configure --disable-device-mapper --disable-static
  make
  mv parted/parted "$UTIL_CHROMEOS_PATH" || exit
  mv parted/.libs/ "$UTIL_CHROMEOS_PATH" # || exit
  mv libparted/.libs/libparted.so "$UTIL_CHROMEOS_PATH/.libs/" || exit
  mv libparted/.libs/libparted.so.2 "$UTIL_CHROMEOS_PATH/.libs/" || exit
  mv libparted/.libs/libparted.so.2.0.3 "$UTIL_CHROMEOS_PATH/.libs/" || exit
}

################################################################################
## Download and compile "unzip" as it is not included in the coreboot-sdk docker image
################################################################################
function downloadUnzip() {
  wget https://downloads.sourceforge.net/infozip/unzip60.tar.gz
  tar xzf unzip60.tar.gz
  cd unzip60 || exit
  make -f unix/Makefile generic
  mv unzip "$UTIL_CHROMEOS_PATH" || exit
}

################################################################################
## MAIN FUNCTION: download ChromeOS ROM and extract mrc.bin into root coreboot
##   directory
#################################################################################
function downloadAndExtractmrc() {
  if [ ! -f "$DOCKER_COREBOOT_DIR/mrc.bin" ]; then
    wget -P "$DOCKER_COREBOOT_DIR/" https://github.com/merge/skulls/raw/master/t440p/mrc.bin

    # Create temp directory
    # mkdir "$DOCKER_COREBOOT_DIR/deb_extract"
    # cd "$DOCKER_COREBOOT_DIR/deb_extract" || exit
    #
    # downloadUudecode
    # downloadParted
    # downloadUnzip
    #
    # # clean up temp directory
    # cd "$DOCKER_COREBOOT_DIR/" || exit
    # rm -rf "$DOCKER_COREBOOT_DIR/deb_extract"
    #
    # # https://doc.coreboot.org/northbridge/intel/haswell/mrc.bin.html
    # make -C "$DOCKER_COREBOOT_DIR/util/cbfstool"
    # cd "$DOCKER_COREBOOT_DIR/util/chromeos" || exit
    #
    # #PATH="$PATH:$DOCKER_COREBOOT_DIR/util/chromeos" LD_LIBRARY_PATH="$UTIL_CHROMEOS_PATH/.libs/:$LD_LIBRARY_PATH" ./crosfirmware.sh peppy || exit
    # ./crosfirmware.sh peppy || exit
    # "$DOCKER_COREBOOT_DIR/util/cbfstool/cbfstool" coreboot-*.bin extract -f mrc.bin -n mrc.bin -r RO_SECTION || exit
    # mv mrc.bin "$DOCKER_COREBOOT_DIR/" || exit
  fi
}
