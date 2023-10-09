#!/bin/sh

Describe "config_and_make.sh"
  Describe "configAndMake"
    PROJECT_PATH=$(realpath .)
    TEST_TMP_DIR="$PROJECT_PATH/spec/test_tmp"
    TEST_TMP_SCRIPTS_DIR="$TEST_TMP_DIR/scripts"
    TEST_TMP_CONFIG_DIR="$TEST_TMP_DIR/configs"

    BeforeAll
      mkdir -p "$TEST_TMP_DIR" || true
      mkdir -p "$TEST_TMP_SCRIPTS_DIR" || true
      mkdir -p "$TEST_TMP_CONFIG_DIR" || true

    cd() {
      echo "cd called with parameters:"
      echo "$@"
    }

    cp() {
      echo "cp called with parameters:"
      echo "$@"
    }

    mv() {
      echo "mv called with parameters:"
      echo "$@"
    }

    make() {
      if [ -z "$*" ]; then
      echo "make called without parameters"
      else
        echo "make called with parameters:"
        echo "$@"
      fi
    }

    export UNIT_TESTING=1

    export DOCKER_COREBOOT_DIR=$TEST_TMP_DIR
    export DOCKER_SCRIPT_DIR=$TEST_TMP_SCRIPTS_DIR
    export DOCKER_COREBOOT_CONFIG_DIR=$TEST_TMP_CONFIG_DIR

    Include "./common/config_and_make.sh"

    It "test no existing config.sh and without commit or tag"
      When call configAndMake
      The line 1 of output should eq "cd called with parameters:"
      The line 2 of output should eq "$TEST_TMP_DIR"
      The line 3 of output should eq "cp called with parameters:"
      The line 4 of output should eq "$DOCKER_SCRIPT_DIR/defconfig $DOCKER_COREBOOT_CONFIG_DIR/defconfig"
      The line 5 of output should eq "Using default config"
      The line 6 of output should eq "make called with parameters:"
      The line 7 of output should eq "defconfig"
      The line 8 of output should eq "make called without parameters"
    End


    It "test no existing config.sh and tag defined"
      export COREBOOT_TAG="some_tag"
      touch "$TEST_TMP_SCRIPTS_DIR/defconfig-some_tag"
      When call configAndMake
      The line 1 of output should eq "cd called with parameters:"
      The line 2 of output should eq "$TEST_TMP_DIR"
      The line 3 of output should eq "cp called with parameters:"
      The line 4 of output should eq "$DOCKER_SCRIPT_DIR/defconfig-some_tag $DOCKER_COREBOOT_CONFIG_DIR/defconfig"
      The line 5 of output should eq "Using config-some_tag"
      The line 6 of output should eq "make called with parameters:"
      The line 7 of output should eq "defconfig"
      The line 8 of output should eq "make called without parameters"
      rm "$TEST_TMP_SCRIPTS_DIR/defconfig-some_tag"
    End


    It "test no existing config.sh and commit defined"
      export COREBOOT_COMMIT="some_commit"
      touch "$TEST_TMP_SCRIPTS_DIR/defconfig-some_commit"
      When call configAndMake
      The line 1 of output should eq "cd called with parameters:"
      The line 2 of output should eq "$TEST_TMP_DIR"
      The line 3 of output should eq "cp called with parameters:"
      The line 4 of output should eq "$DOCKER_SCRIPT_DIR/defconfig-some_commit $DOCKER_COREBOOT_CONFIG_DIR/defconfig"
      The line 5 of output should eq "Using config-some_commit"
      The line 6 of output should eq "make called with parameters:"
      The line 7 of output should eq "defconfig"
      The line 8 of output should eq "make called without parameters"
      rm "$TEST_TMP_SCRIPTS_DIR/defconfig-some_commit"
    End

    It "test existing config.sh"
      touch "$TEST_TMP_DIR/.config"
      touch "$TEST_TMP_DIR/defconfig"
      When call configAndMake
      The line 1 of output should eq "cd called with parameters:"
      The line 2 of output should eq "$TEST_TMP_DIR"
      The line 3 of output should eq "Using existing config"
      The line 4 of output should eq "make called with parameters:"
      The line 5 of output should eq "savedefconfig"
      The line 6 of output should eq "mv called with parameters:"
      The line 7 of output should eq "$TEST_TMP_DIR/defconfig $DOCKER_COREBOOT_CONFIG_DIR/"
      The line 8 of output should eq "make called with parameters:"
      The line 9 of output should eq "defconfig"
      The line 10 of output should eq "make called without parameters"
      rm "$TEST_TMP_DIR/.config"
      rm "$TEST_TMP_DIR/defconfig"
    End

    It "test no existing config.sh and without commit or tag but with config flag"
      export COREBOOT_CONFIG=1
      When call configAndMake
      The line 1 of output should eq "cd called with parameters:"
      The line 2 of output should eq "$TEST_TMP_DIR"
      The line 3 of output should eq "cp called with parameters:"
      The line 4 of output should eq "$DOCKER_SCRIPT_DIR/defconfig $DOCKER_COREBOOT_CONFIG_DIR/defconfig"
      The line 5 of output should eq "Using default config"
      The line 6 of output should eq "make called with parameters:"
      The line 7 of output should eq "defconfig"
      The line 8 of output should eq "make called with parameters:"
      The line 9 of output should eq "nconfig"
      The line 10 of output should eq "make called with parameters:"
      The line 11 of output should eq "savedefconfig"
      The line 12 of output should eq "make called without parameters"
    End

    AfterAll
      rmdir "$TEST_TMP_SCRIPTS_DIR"
      rmdir "$TEST_TMP_CONFIG_DIR"
      rmdir "$TEST_TMP_DIR"
      export UNIT_TESTING=0
  End
End
