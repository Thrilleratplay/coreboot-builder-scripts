Coreboot Builder scripts
==========
Bash scripts and config files to simplify building of Coreboot using the official coreboot-sdk docker image.



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

Once the build is complete, you will be asked to baackup the existing and flash the new rom.

NOTE: Internal flashing can only be complete if Coreboot has already been flashed externally and ifd has been unlocked.

## Examples
* Build the latest release ([Coreboot Releases](https://coreboot.org/downloads.html)):  
  `./build.sh X230`

* Build the latest commit  
    `./build.sh --config --bleeding-edge X230`
