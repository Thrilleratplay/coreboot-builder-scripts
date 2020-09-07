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
    The line 1 of output should eq "-p internal:laptop=force_I_want_a_brick -r test_name.rom.backup -c MX25L6405"
    The line 2 of output should eq "-p internal:laptop=force_I_want_a_brick -w test_name.rom -c MX25L6405"
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
