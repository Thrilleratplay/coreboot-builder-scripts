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

flashrom -p internal:laptop=force_I_want_a_brick -r "$1.backup" -c MX25L6405 && flashrom -p internal:laptop=force_I_want_a_brick -w "$1" -c MX25L6405
