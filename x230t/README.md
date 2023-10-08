# Lenovo X230 Tablet

### Compiling
Build the latest merged into the master git branch:  
`./build.sh --bleeding-edge x230t`

Latest stable release:  
 `./build.sh x230t`

### Output
 ##### Internal flashing
`coreboot_lenovo-x230t-complete.rom` - The complete Coreboot ROM is the 12MB version used for internal flashing.   
`coreboot_lenovo-x230t-complete.rom.sha256` - sha256 checksum of 12MB Coreboot Rom

*NOTE:* As this is compiled without the stock BIOS, all IFD, GBE and ME blobs are stubs.  Use the `flash.sh` script at the root of the directory.


##### External flashing
`coreboot_lenovo-x230t-top.rom` - The 4MB Coreboot BIOS that can be flashed externally onto the top BIOS chip.
`coreboot_lenovo-x230t-top.rom.sha256` - sha256 checksum of 4MB Coreboot BIOS

*NOTE:* See [Skulls](https://github.com/merge/skulls/tree/master/x230t) for instructions on how to flash the top BIOS chip as well as unlocking the IFD and cleaning Intel ME
