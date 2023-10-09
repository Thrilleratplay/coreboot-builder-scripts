Coreboot Builder scripts
==========
[![Build Status](https://travis-ci.org/Thrilleratplay/coreboot-builder-scripts.svg?branch=master)](https://travis-ci.org/Thrilleratplay/coreboot-builder-scripts)


Bash scripts and config files to simplify building of Coreboot using the official coreboot-sdk docker image.



## BEFORE YOU BEGIN !!!!!

If your device has the stock BIOS installed, you must flash the BIOS chip externally first. I suggest starting with [Skulls](https://github.com/merge/skulls) which makes that first install as painless as possible.  

While the compiled Coreboot builds this repo generates can be flashed externally, the intent of this project is to simplify updating an existing Coreboot BIOS.  

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

| Model | SeaBIOS | EDK2 |
| --- | --- | --- |
| [T430](t430/README.md) | | |
| W530 | | |
| W541 | | |
| [X220](x220/README.md) | X | |
| [X220 Tablet](x220/README.md) | | |
| [X230](x230/README.md) | | |
| [X230 Tablet](x230t/README.md) | | |
| X230 FHD | | |
| X1 Carbon Gen 1 | | |

## Configuration

The make configs include
* Primary payload is the latest stable SeaBIOS
* All secondary payloads are added by default
* High resolution libgfxinit is used over legacy framebuffer and VGA BIOS
