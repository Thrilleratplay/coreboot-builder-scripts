#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+
set -e

flashrom -p internal -r "$1.backup" && flashrom -p internal --layout "$PWD/x230/layout.txt" --image bios -w "$1"
