#!/bin/sh
# SPDX-License-Identifier: GPL-3.0+
set -e

################################################################################
## Menu
################################################################################

## Parse avialble models from directory names
AVAILABLE_MODELS=$(find ./ -maxdepth 1 -mindepth 1 -type d | sed  's/\.\///g' | grep -Ev "common|git")

## Help menu
usage()
{
  echo "Usage: "
  echo
  echo "  $0 <model>"
  echo
  echo
  echo "Available models:"
  for AVAILABLE_MODEL in $AVAILABLE_MODELS; do
      echo "$(printf '\t')$AVAILABLE_MODEL"
  done
}

## Validate and normalize given model number
MODEL=$(echo "$@" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]');

## Check if valid model
if [ -z "$MODEL" ] || [ ! -d "$PWD/$MODEL" ]; then
  usage
  exit 1;
fi;

ROM_FILE=$(find "$PWD/$MODEL/build/" -name "coreboot_*-complete.rom" -printf "%T+\\t%p\\n" | sort -r | cut -f2 | head -n1 2>/dev/null)

## Move new files here
if [ -z "$ROM_FILE" ]; then
  echo "Could not find Coreboot rom file for $MODEL"
  exit 1;
fi

if [ ! -f "$PWD/$MODEL/layout.txt" ]; then
  echo "Could not find layout file for $MODEL"
  exit 1;
fi

while true; do
    printf "Do you wish to flash the bios with %s?  " "$ROM_FILE"
    read -r yn
    case $yn in
        [Yy]* )
          # Back up and write BIOS
          sudo "$PWD/$MODEL/./flashrom.sh" "$ROM_FILE"
          break;;
        [Nn]* )
          exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
