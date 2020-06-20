#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+
set -e

flashrom -p internal -r "$1.backup" && flashrom -p internal:boardmismatch=force --layout "$PWD/x230_fhd/layout.txt" --image bios -w "$1"
