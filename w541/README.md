# Lenovo W541

### Compiling
Build the latest merged into the master git branch:  
`./build.sh --bleeding-edge w541`

Latest stable release:  
 `./build.sh w541`

### Output
 ##### Internal flashing
`coreboot_lenovo-w541-complete.rom` - The complete Coreboot ROM is the 12MB version used for internal flashing.   
`coreboot_lenovo-w541-complete.rom.sha256` - sha256 checksum of 12MB Coreboot Rom

*NOTE:* As this is compiled without the stock BIOS, all IFD, GBE and ME blobs are stubs.  Use the `flash.sh` script at the root of the directory.


##### External flashing
`coreboot_lenovo-w541-top.rom` - The 4MB Coreboot BIOS that can be flashed externally onto the top BIOS chip.
`coreboot_lenovo-w541-top.rom.sha256` - sha256 checksum of 4MB Coreboot BIOS

