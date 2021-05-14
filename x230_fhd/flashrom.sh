#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+
set -e

if ! command -v flashrom &> /dev/null; then
    echo "Flashrom cannot be found.  Install and try again."
    exit 1
fi

if [ -z "$1" ]; then
    echo "File name needed.  No argument supplied.";
    exit 1;
fi

## NOTE: if flashing from X230, the flash write command will need  to be changed
##       from `-p internal:boardmismatch=force` to `-p internal:boardmismatch=force`

flashrom -p internal -r "$1.backup" && flashrom -p internal --layout "$PWD/x230_fhd/layout.txt" --image bios -w "$1"
