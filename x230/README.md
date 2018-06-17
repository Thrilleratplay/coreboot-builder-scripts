# Lenovo X230

### Prep work
As long as only the BIOS partition is being flashed without the VGA blob, the stock BIOS
 back up is not required to compile.

### Compiling
Build the latest merged into the master git branch:  
`./build.sh --bleeding-edge x230`

Latest stable release:  
 `./build.sh x230`

### Output
 ##### Internal flashing
`coreboot_lenovo-x230-complete.rom` - The complete Coreboot ROM is the 12MB version used for internal flashing.   
`coreboot_lenovo-x230-complete.rom.sha256` - sha256 checksum of 12MB Coreboot Rom

*NOTE:* As this is compiled without the stock BIOS, all IFD, GBE and ME blobs are stubs.  Use the `flash.sh` script at the root of the directory.


##### External flashing
`coreboot_lenovo-x230-top.rom` - The 4MB Coreboot BIOS that can be flashed externally onto the top BIOS chip.
`coreboot_lenovo-x230-top.rom.sha256` - sha256 checksum of 4MB Coreboot BIOS

*NOTE:* See [Skulls](https://github.com/merge/skulls/tree/master/x230) for instructions on how to flash the top BIOS chip as well as unlocking the IFD and cleaning Intel ME
