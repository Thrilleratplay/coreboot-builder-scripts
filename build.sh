#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+
set -e

## import variables
source "./common/variables.sh"

################################################################################
## Menu
################################################################################

## Parse avialble models from directory names
AVAILABLE_MODELS=$(ls -d */ | sed  's/\///g' | fgrep -v common)

## Help menu
usage()
{
  echo "Usage: "$'\n'
  echo "  $0 [-t <TAG>] [-c <COMMIT>] [--config] [--bleeding-edge] [--clean-slate] <model>"$'\n'
  echo "  --bleeding-edge              Build from the latest commit"
  echo "  --clean-slate                Purge previous build directory and config"
  echo "  -c, --commit <commit>        Git commit hash"
  echo "  -h, --help                   Show this help"
  echo "  -i, --config                 Execute with interactive make config"
  echo "  -t, --tag <tag>              Git tag/version"
  echo "If a tag, commit or bleeding-edge flag is not given, the latest Coreboot release will be built."

  echo $'\n'"Available models:"
  for AVAILABLE_MODEL in $AVAILABLE_MODELS; do
      echo $'\t'$AVAILABLE_MODEL
  done
}

## Iterate through command line parameters
while :
do
    case "$1" in
      --clean-slate)
        CLEAN_SLATE=true
        shift 1;;
      -c | --commit)
        COREBOOT_COMMIT="$2"
        shift 2;;
      --bleeding-edge)
          COREBOOT_COMMIT="master"
          shift 1;;
      -h | --help)
        usage >&2
        exit 0;;
      -i | --config)
        COREBOOT_CONFIG=true
        shift 1;;
      -t | --tag)
        COREBOOT_TAG="$2"
        shift 2;;
      -*)
        echo "Error: Unknown option: $1" >&2
        usage >&2
        exit 1;;
      *)
        break;;
    esac
done

## Validate and normalize given model number
MODEL=$(echo "$@" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]');

## Check if valid model
if [[ -z $MODEL || ! -d "$PWD/$MODEL" ]]; then
  usage
  exit 1;
fi;

################################################################################
################################################################################

if [ ! -d "$PWD/$MODEL/build" ]; then
  mkdir "$PWD/$MODEL/build"
elif [ $CLEAN_SLATE ]; then
  rm -rf "$PWD/$MODEL/build" || true
  mkdir "$PWD/$MODEL/build"
fi

## Run Docker
docker run --rm -it \
    --user "$(id -u):$(id -g)" \
    -v "$PWD/$MODEL/build":$DOCKER_COREBOOT_DIR \
    -v $PWD/$MODEL:$DOCKER_SCRIPT_DIR \
    -v $PWD/common:$DOCKER_COMMON_SCRIPT_DIR \
    -e COREBOOT_COMMIT=$COREBOOT_COMMIT \
    -e COREBOOT_TAG=$COREBOOT_TAG \
    -e COREBOOT_CONFIG=$COREBOOT_CONFIG \
    coreboot/coreboot-sdk:$COREBOOT_SDK_VERSION \
    /home/coreboot/scripts/compile.sh

## Move new files here
if [ ! -z "$(ls $PWD/$MODEL/build/coreboot_*)" ]; then
  mv "$PWD/$MODEL/build/coreboot_"* "$PWD"
fi