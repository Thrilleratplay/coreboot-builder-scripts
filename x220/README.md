# Lenovo x220

### Prep work
A flashrom binary dump of the stock x220 BIOS is needed to compile Coreboot.

* Place a copy of this dump under the x220 `stock_bios` directory and name it `stock_bios.bin` (to put it another way `./x220/stock_bios/stock_bios.bin`)

### Compiling
Build the latest merged into the master git branch:  
`./build.sh --bleeding-edge x220`

Latest stable release:  
 `./build.sh x220`

### Output

`coreboot_lenovo-x220-complete.rom` - The complete Coreboot ROM is the 8MB version used for internal or external flashing.   
`coreboot_lenovo-x220-complete.rom.sha256` - sha256 checksum of 8MB Coreboot Rom
