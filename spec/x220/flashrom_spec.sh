#!/bin/sh

Describe "x220 flashrom"
  PROJECT_PATH=$(realpath .)

  flashrom() {
    echo "$@"
  }

  It "test flashrom.sh fails without name argument"
    When run source ./x220/flashrom.sh
    The status should be failure
    The output should eq "File name needed.  No argument supplied."
  End

  It "test flashrom.sh name argument"
    When run source ./x220/flashrom.sh test_name.rom
    The line 1 of output should eq "-p internal:ich_spi_mode=hwseq -r test_name.rom.backup --ifd --image bios"
    The line 2 of output should eq "-p internal:ich_spi_mode=hwseq -w test_name.rom --ifd --image bios"
  End

  command() {
    return 1;
  }

  It "test flashrom.sh name argument"
    When run source ./x220/flashrom.sh
    The status should be failure
    The output should eq "Flashrom cannot be found.  Install and try again."
  End
End
