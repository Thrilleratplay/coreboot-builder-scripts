# Coreboot Builder scripts (SeaBIOS payload)

[![Build Status](https://travis-ci.org/Thrilleratplay/coreboot-builder-scripts.svg?branch=master)](https://travis-ci.org/Thrilleratplay/coreboot-builder-scripts)

Bash scripts and config files to simplify building of Coreboot using the official coreboot-sdk docker image.

## BEFORE YOU BEGIN !!!!!

SeaBIOS is a legacy BIOS payload.  If you would want a UEFI payload, it is advised to use the [edk2 branch](https://github.com/Thrilleratplay/coreboot-builder-scripts/tree/edk2)

If your device has the stock BIOS installed, you must flash the BIOS chip externally first. I suggest starting with [Skulls](https://github.com/merge/skulls) which makes that first install as painless as possible.  

While the compiled Coreboot builds this repo generates can be flashed externally, see [External flashable ROMs](#external-flashable-roms) the intent of this project is to simplify updating an existing Coreboot BIOS.  

## Usage

```bash
./build.sh [-t <TAG>] [-c <COMMIT>] [--config] [--bleeding-edge] [--clean-slate] <model>

  --bleeding-edge              Build from the latest commit
  --clean-slate                Purge previous build directory and config
  -c, --commit <commit>        Git commit hash
  -h, --help                   Show this help
  -i, --config                 Execute with interactive make config
  -t, --tag <tag>              Git tag/version
If a tag, commit or bleeding-edge flag is not given, the latest Coreboot release will be built
```

Once the build is complete, you will be asked to backup the existing and flash the new rom.

NOTE: Internal flashing can only be complete if Coreboot has already been flashed externally and ifd has been unlocked.

## Examples

* Build the latest release ([Coreboot Releases](https://coreboot.org/downloads.html)):  
  `./build.sh X230`

* Build the latest commit  
    `./build.sh --config --bleeding-edge X230`

## Device Testing

Any config denoted with an `X` is a device I own and have personally tested the latest configuration on.

| Model | SeaBIOS | EDK2 | Total size/chip configuration |
| --- | --- | --- | --- |
| [T430](t430/README.md) | X | X | 12Mb (8Mb + 4Mb) |
| [W530](W530/README.md) | X | X | 12Mb (8Mb + 4Mb) |
| [X220](x220/README.md) | X | X | 8Mb |
| [X220 Tablet](x220/README.md) | X | X | 8Mb |
| [X230](x230/README.md) | | | 12Mb (8Mb + 4Mb) |
| [X230 Tablet](x230t/README.md) | X |X | 12Mb (8Mb + 4Mb) |

**Other models:**

| Model | Note |
| --- | --- |
| W541 | WIP |
| X1 Carbon Gen1 | WIP |
| x230 FHD Mod| I own one but has a short and cannot test |

## Bootsplash

The GIMP file for the bootsplash can be [found here](https://github.com/Thrilleratplay/bootsplash-coreboot).
  If creating a custom bootsplash be sure to follow the instructions found in this
  [Purism blog post( scroll down to "The boot splash—Beauty is Pain")](https://puri.sm/posts/librem-13-coreboot-report-february-25th-2017/)

## External flashable ROMs

A full externally flashable ROM can be generated using these scrips if coreboot is build with:

* Intel Firmware Descriptor (IFD)
* Intel Management Engine (ME)
* Intel Gigabit Ethernet firmware (GbE)

These are included with your stock BIOS, which you should have a backup of having read the original contends using flashrom.
  There is a helper function in each model's `compile.sh` that will compile ifdtool, extract the pieces and place them in the
  default spots for coreboot to locate.

Steps:

1. If the backup was created by reading from two physical chips (See `Total size/chip configuration` above) is from two chips,
  they can be concatenated together using the cat command to create a full 12Mb ROM `cat my_8mb_backup.rom my_4mb_backup.rom > stock_bios.bin`
  .  If the model only have one 8mb chip, skip this step.
2. Copy the full backup ROM into the `stock_bios` directory under the corresponding model directory.
3. Uncomment the following line in model's `config.sh` file.  `stock_bios.bin` should be changed to be the name of the file in the `stock_bios` directory.

```sh
# extractStockBios "$MAINBOARD" "$MODEL" "stock_bios.bin"
```

4. Use the `--config` flag to enter the config menu.  Under `Chipset` enable the following:
   * `Add Intel descriptor.bin file`
   * `Add Intel ME/TXE firmware`
     * `Verify the integrity of the supplied ME/TXE firmware`
   * `Strip down the Intel ME/TXE firmware`
   * `Add gigabit ethernet configuration`
