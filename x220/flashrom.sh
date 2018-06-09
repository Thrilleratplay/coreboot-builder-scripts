#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+
set -e

flashrom -p internal:laptop=force_I_want_a_brick --ifd --image bios -w $1;
