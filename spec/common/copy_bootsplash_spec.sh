#!/bin/sh

Describe "copy_bootsplash.sh"
  Describe "copySeaBiosBootsplash"
    PROJECT_PATH=$(realpath .)
    TEST_TMP_DIR="$PROJECT_PATH/spec/test_tmp"
    TEST_TMP_COMMON_SCRIPTS_DIR="$TEST_TMP_DIR/common_scripts"

    BeforeAll
      mkdir -p "$TEST_TMP_DIR" || true
      mkdir -p "$TEST_TMP_COMMON_SCRIPTS_DIR" || true

    cp() {
      echo "cp called with parameters:"
      echo "$@"
    }

    export UNIT_TESTING=1

    export DOCKER_COREBOOT_DIR=$TEST_TMP_DIR
    export DOCKER_COMMON_SCRIPT_DIR=$TEST_TMP_COMMON_SCRIPTS_DIR
    export SEABIOS_BOOTSPLASH_JPEG="awesome_bootsplash.jpg"

    Include "./common/copy_bootsplash.sh"

    It "test SeaBIOS Bootsplash is copied if it does not exits"
      When call copySeaBiosBootsplash
      The line 1 of output should eq "cp called with parameters:"
      The line 2 of output should eq "$TEST_TMP_COMMON_SCRIPTS_DIR/$SEABIOS_BOOTSPLASH_JPEG $TEST_TMP_DIR/bootsplash.jpg"
      The line 3 of output should eq "Copied SeaBIOS bootslash.jpg"
    End

    Before
      touch "$TEST_TMP_DIR/bootsplash.jpg"

    It "test SeaBIOS Bootsplash is not copied if it does exits"
      When call copySeaBiosBootsplash
      The line 1 of output should eq "bootsplash.jpg exists.  Skipping."
    End

    AfterAll
      rm "$TEST_TMP_DIR/bootsplash.jpg"
      rmdir "$TEST_TMP_COMMON_SCRIPTS_DIR"
      rmdir "$TEST_TMP_DIR"
      export UNIT_TESTING=0
  End
End