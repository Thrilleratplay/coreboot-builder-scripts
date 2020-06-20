#!/bin/sh

Describe "x230_fhd flashrom"
  PROJECT_PATH=$(realpath .)

  flashrom() {
    echo "$@"
  }

  It "test flashrom.sh fails without name argument"
    When run source ./x230_fhd/flashrom.sh
    The status should be failure
    The output should eq "File name needed.  No argument supplied."
  End

  It "test flashrom.sh name argument"
    When run source ./x230_fhd/flashrom.sh test_name.rom
    The line 1 of output should eq "-p internal -r test_name.rom.backup"
    The line 2 of output should eq "-p internal --layout $PROJECT_PATH/x230_fhd/layout.txt --image bios -w test_name.rom"
  End

  command() {
    return 1;
  }

  It "test flashrom.sh name argument"
    When run source ./x230_fhd/flashrom.sh
    The status should be failure
    The output should eq "Flashrom cannot be found.  Install and try again."
  End
End
