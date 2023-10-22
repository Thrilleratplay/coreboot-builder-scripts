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

flashrom -p internal:ich_spi_mode=hwseq -r "$1.backup" --layout "$PWD/x220/layout.txt" --image bios && flashrom -p internal:ich_spi_mode=hwseq -w "$1" --layout "$PWD/x220/layout.txt" --image bios
