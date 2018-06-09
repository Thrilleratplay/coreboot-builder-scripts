#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+
set -e

################################################################################
## Menu
################################################################################

## Parse avialble models from directory names
AVAILABLE_MODELS=$(ls -d */ | sed  's/\///g' | fgrep -v common)

## Help menu
usage()
{
  echo "Usage: "$'\n'
  echo "  $0 <model>"$'\n'

  echo $'\n'"Available models:"
  for AVAILABLE_MODEL in $AVAILABLE_MODELS; do
      echo $'\t'$AVAILABLE_MODEL
  done
}

## Validate and normalize given model number
MODEL=$(echo "$@" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]');

## Check if valid model
if [[ -z $MODEL || ! -d "$PWD/$MODEL" ]]; then
  usage
  exit 1;
fi;

ROM_FILE=$(ls -t "$PWD/$MODEL/build/coreboot_"*"-complete.rom" 2>/dev/null | head -n1)

## Move new files here
if [ -z $ROM_FILE ]; then
  echo "Could not find Coreboot rom file for $MODEL"
  exit 1;
fi

if [ ! -f "$PWD/$MODEL/layout.txt" ]; then
  echo "Could not find layout file for $MODEL"
  exit 1;
fi

while true; do
    read -p "Do you wish to flash the bios with $ROM_FILE?  " yn
    case $yn in
        [Yy]* )
          # Back up and write BIOS
          sudo flashrom -p internal -r "$ROM_FILE.backup" && sudo "$PWD/$MODEL/./flashrom.sh" $ROM_FILE
          break;;
        [Nn]* )
          exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
