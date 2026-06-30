# Lenovo m720q

### Known issues

* [Front audio jacks do not work](https://review.coreboot.org/c/coreboot/+/80609)

### Compiling

Build the latest merged into the master git branch:  
`./build.sh --bleeding-edge m720q`

Latest stable release:  
 `./build.sh m720q`

### Output

##### Internal flashing

`coreboot_lenovo-m720q-complete.rom` - The complete Coreboot ROM is the 16MB version used for internal flashing.
`coreboot_lenovo-m720q-complete.rom.sha256` - sha256 checksum of 16MB Coreboot Rom

*NOTE:* The default config is compiled without the stock BIOS, all IFD, GBE and ME blobs are stubs.  Use the `flash.sh` script at the root of the directory.

##### External flashing

NOTE: If flashing externally, be sure to include the IFD, GBE and ME blobs.  Failing to do so will prevent booting.  

*NOTE:* Version of `me_cleaner` included in the coreboot repo is does not compatible with ME V12.  Use the [XutaxKamay/me_cleaner](https://github.com/XutaxKamay/me_cleaner) fork with the `--soft-disable` flag.

### Debug

The debug logs are available through the serial port on COM1.  To connect, you will need:

* the serial port adapter. Search eBay for `FRU 04X2733` connected to COM1 (this is labeled on the board and is near the back of the case and is close to the wifi antenna connector/cutout).
* A USB to DB9 RS-232 Male cable.
  
Once connected, start a serial terminal emulator such as [minicom](https://salsa.debian.org/minicom-team/minicom) or [tio](https://github.com/tio/tio) before powering on the m720q.
