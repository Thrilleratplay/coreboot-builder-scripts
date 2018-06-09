#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+
set -e

flashrom -p internal:laptop=force_I_want_a_brick -r "$1.backup" -c MX25L6405 && flashrom -p internal:laptop=force_I_want_a_brick -w "$1" -c MX25L6405
