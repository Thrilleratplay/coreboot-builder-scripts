#!/bin/sh

Describe "flash.sh"
  PROJECT_PATH=$(realpath .)
  TEST_TMP_DIR="$PROJECT_PATH/spec/test_tmp"

  BeforeAll
      mkdir -p "$TEST_TMP_DIR" || true
      mkdir -p "$TEST_TMP_DIR/t800" || true
      mkdir -p "$TEST_TMP_DIR/t1000" || true

  sudo() {
    echo ""
    echo "sudo called with parameters:"
    echo "$@"
  }

  It "test flashrom.sh fails without name argument"

    cd "$TEST_TMP_DIR" || exit
    When run source "$PROJECT_PATH/flash.sh"
    The status should be failure
    The line 1 of output should eq "Usage: "
    The line 2 of output should eq ""
    The line 3 of output should eq "  $0 <model>"
    The line 4 of output should eq ""
    The line 5 of output should eq ""
    The line 6 of output should eq "Available models:"
    The line 7 of output should eq "$(printf '\t')t800"
    The line 8 of output should eq "$(printf '\t')t1000"
  End

  It "test flashrom.sh fails with invalid name argument"
    cd "$TEST_TMP_DIR" || exit
    When run source "$PROJECT_PATH/flash.sh" "t2"
    The status should be failure
    The line 1 of output should eq "Usage: "
    The line 2 of output should eq ""
    The line 3 of output should eq "  $0 <model>"
    The line 4 of output should eq ""
    The line 5 of output should eq ""
    The line 6 of output should eq "Available models:"
    The line 7 of output should eq "$(printf '\t')t800"
    The line 8 of output should eq "$(printf '\t')t1000"
  End

  It "test flashrom.sh fails with valid name argument but no rom file to flash"
    cd "$TEST_TMP_DIR" || exit
    mkdir -p "$TEST_TMP_DIR/t800/build" || true
    When run source "$PROJECT_PATH/flash.sh" "t800"
    The status should be failure
    The output should eq "Could not find Coreboot rom file for t800"
    rmdir "$TEST_TMP_DIR/t800/build" || true
  End

  It "test flashrom.sh fails with valid name argument but no layout file for flashrom"
    cd "$TEST_TMP_DIR" || exit
    mkdir -p "$TEST_TMP_DIR/t800/build" || true
    touch "$TEST_TMP_DIR/t800/build/coreboot_t800-complete.rom"
    When run source "$PROJECT_PATH/flash.sh" "t800"
    The status should be failure
    The output should eq "Could not find layout file for t800"
    rm "$TEST_TMP_DIR/t800/build/coreboot_t800-complete.rom"
    rmdir "$TEST_TMP_DIR/t800/build" || true
  End


  It "test flashrom.sh fails with valid name argument, rom file and layout file but say no"
    cd "$TEST_TMP_DIR" || exit
    mkdir -p "$TEST_TMP_DIR/t800/build" || true
    touch "$TEST_TMP_DIR/t800/build/coreboot_t800-complete.rom"
    touch "$TEST_TMP_DIR/t800/layout.txt"
    Data
      #|n
    End
    When run source "$PROJECT_PATH/flash.sh" "t800"
    The output should eq "Do you wish to flash the bios with $TEST_TMP_DIR/t800/build/coreboot_t800-complete.rom?  "
    rm "$TEST_TMP_DIR/t800/layout.txt"
    rm "$TEST_TMP_DIR/t800/build/coreboot_t800-complete.rom"
    rmdir "$TEST_TMP_DIR/t800/build" || true
  End

  It "test flashrom.sh fails with valid name argument, rom file and layout file and say an invalid answer then yes"
    cd "$TEST_TMP_DIR" || exit
    mkdir -p "$TEST_TMP_DIR/t800/build" || true
    touch "$TEST_TMP_DIR/t800/build/coreboot_t800-complete.rom"
    touch "$TEST_TMP_DIR/t800/layout.txt"
    Data
      #|7
      #|y
    End
    When run source "$PROJECT_PATH/flash.sh" "t800"
    The line 1 of output should eq "Do you wish to flash the bios with $TEST_TMP_DIR/t800/build/coreboot_t800-complete.rom?  Please answer yes or no."
    The line 2 of output should eq "Do you wish to flash the bios with $TEST_TMP_DIR/t800/build/coreboot_t800-complete.rom?  "
    The line 3 of output should eq "sudo called with parameters:"
    The line 4 of output should eq "$TEST_TMP_DIR/t800/./flashrom.sh $TEST_TMP_DIR/t800/build/coreboot_t800-complete.rom"
    rm "$TEST_TMP_DIR/t800/layout.txt"
    rm "$TEST_TMP_DIR/t800/build/coreboot_t800-complete.rom"
    rmdir "$TEST_TMP_DIR/t800/build" || true
  End

  AfterAll
      rmdir "$TEST_TMP_DIR/t800"
      rmdir "$TEST_TMP_DIR/t1000"
      rmdir "$TEST_TMP_DIR"
End
