#!/bin/sh

Describe "build.sh"
  PROJECT_PATH=$(realpath .)
  TEST_TMP_DIR="$PROJECT_PATH/spec/test_tmp"

  export UNIT_TESTING=1

  BeforeAll
      mkdir -p "$TEST_TMP_DIR" || true
      mkdir -p "$TEST_TMP_DIR/t800" || true
      mkdir -p "$TEST_TMP_DIR/t800/stock_bios" || true
      mkdir -p "$TEST_TMP_DIR/t1000" || true
      export DOCKER_ROOT_DIR="/home/coreboot"
      export DOCKER_SCRIPT_DIR="$DOCKER_ROOT_DIR/scripts"
      export DOCKER_COMMON_SCRIPT_DIR="$DOCKER_ROOT_DIR/common_scripts"
      export DOCKER_COREBOOT_DIR="$DOCKER_ROOT_DIR/cb_build"
      export DOCKER_COREBOOT_CONFIG_DIR="$DOCKER_COREBOOT_DIR/configs"
      export DOCKER_STOCK_BIOS_DIR="$DOCKER_ROOT_DIR/stock_bios/"
      export COREBOOT_SDK_VERSION="12345"

  docker() {
    echo "$@"
  }

  It "test with no paramters"
    cd "$TEST_TMP_DIR" || exit
    When run source "$PROJECT_PATH/build.sh"
    The status should be failure

    The line 1 of output should eq "Usage: "
    The line 2 of output should eq ""
    The line 3 of output should eq "  $0 [-t <TAG>] [-c <COMMIT>] [--config] [--bleeding-edge] [--clean-slate] <model>"
    The line 4 of output should eq ""
    The line 5 of output should eq "  --bleeding-edge              Build from the latest commit"
    The line 6 of output should eq "  --clean-slate                Purge previous build directory and config"
    The line 7 of output should eq "  -c, --commit <commit>        Git commit hash"
    The line 8 of output should eq "  --flash                      Flash BIOS if build is successful"
    The line 9 of output should eq "  -h, --help                   Show this help"
    The line 10 of output should eq "  -i, --config                 Execute with interactive make config"
    The line 11 of output should eq "  -t, --tag <tag>              Git tag/version"
    The line 12 of output should eq ""
    The line 13 of output should eq "If a tag, commit or bleeding-edge flag is not given, the latest Coreboot release will be built."
    The line 14 of output should eq ""
    The line 15 of output should eq ""
    The line 16 of output should eq "Available models:"
    The line 17 of output should eq "$(printf '\t')t1000"
    The line 18 of output should eq "$(printf '\t')t800"
  End

  It "test with help"
    cd "$TEST_TMP_DIR" || exit
    When run source "$PROJECT_PATH/build.sh" -h

    The line 1 of output should eq "Usage: "
    The line 2 of output should eq ""
    The line 3 of output should eq "  $0 [-t <TAG>] [-c <COMMIT>] [--config] [--bleeding-edge] [--clean-slate] <model>"
    The line 4 of output should eq ""
    The line 5 of output should eq "  --bleeding-edge              Build from the latest commit"
    The line 6 of output should eq "  --clean-slate                Purge previous build directory and config"
    The line 7 of output should eq "  -c, --commit <commit>        Git commit hash"
    The line 8 of output should eq "  --flash                      Flash BIOS if build is successful"
    The line 9 of output should eq "  -h, --help                   Show this help"
    The line 10 of output should eq "  -i, --config                 Execute with interactive make config"
    The line 11 of output should eq "  -t, --tag <tag>              Git tag/version"
    The line 12 of output should eq ""
    The line 13 of output should eq "If a tag, commit or bleeding-edge flag is not given, the latest Coreboot release will be built."
    The line 14 of output should eq ""
    The line 15 of output should eq ""
    The line 16 of output should eq "Available models:"
    The line 17 of output should eq "$(printf '\t')t1000"
    The line 18 of output should eq "$(printf '\t')t800"
  End

  It "test with invalid model"
    cd "$TEST_TMP_DIR" || exit
    When run source "$PROJECT_PATH/build.sh" t2
    The status should be failure

    The line 1 of output should eq "Usage: "
    The line 2 of output should eq ""
    The line 3 of output should eq "  $0 [-t <TAG>] [-c <COMMIT>] [--config] [--bleeding-edge] [--clean-slate] <model>"
    The line 4 of output should eq ""
    The line 5 of output should eq "  --bleeding-edge              Build from the latest commit"
    The line 6 of output should eq "  --clean-slate                Purge previous build directory and config"
    The line 7 of output should eq "  -c, --commit <commit>        Git commit hash"
    The line 8 of output should eq "  --flash                      Flash BIOS if build is successful"
    The line 9 of output should eq "  -h, --help                   Show this help"
    The line 10 of output should eq "  -i, --config                 Execute with interactive make config"
    The line 11 of output should eq "  -t, --tag <tag>              Git tag/version"
    The line 12 of output should eq ""
    The line 13 of output should eq "If a tag, commit or bleeding-edge flag is not given, the latest Coreboot release will be built."
    The line 14 of output should eq ""
    The line 15 of output should eq ""
    The line 16 of output should eq "Available models:"
    The line 17 of output should eq "$(printf '\t')t1000"
    The line 18 of output should eq "$(printf '\t')t800"
  End

  It "test with only valid model"
    cd "$TEST_TMP_DIR" || exit
    When run source "$PROJECT_PATH/build.sh" t800
    The status should be failure
    The output should eq "run --rm -it --user $(id -u):$(id -g) -v $TEST_TMP_DIR/t800/build:/home/coreboot/cb_build -v $TEST_TMP_DIR/t800:/home/coreboot/scripts -v $TEST_TMP_DIR/common:/home/coreboot/common_scripts -v $TEST_TMP_DIR/t800/stock_bios:/home/coreboot/stock_bios/:ro -e COREBOOT_COMMIT= -e COREBOOT_TAG= -e COREBOOT_CONFIG= coreboot/coreboot-sdk:12345 /home/coreboot/scripts/compile.sh"
  End


  It "test with valid model and clean slate flag"
    cd "$TEST_TMP_DIR" || exit
    touch "$TEST_TMP_DIR/t800/build/random_file"
    When run source "$PROJECT_PATH/build.sh" --clean-slate t800
    The status should be failure
    The output should eq "run --rm -it --user $(id -u):$(id -g) -v $TEST_TMP_DIR/t800/build:/home/coreboot/cb_build -v $TEST_TMP_DIR/t800:/home/coreboot/scripts -v $TEST_TMP_DIR/common:/home/coreboot/common_scripts -v $TEST_TMP_DIR/t800/stock_bios:/home/coreboot/stock_bios/:ro -e COREBOOT_COMMIT= -e COREBOOT_TAG= -e COREBOOT_CONFIG= coreboot/coreboot-sdk:12345 /home/coreboot/scripts/compile.sh"
    The file "$TEST_TMP_DIR/t800/build/random_file" should not be exist
  End


  It "test with valid model and commit flag"
    cd "$TEST_TMP_DIR" || exit
    When run source "$PROJECT_PATH/build.sh" -c abc123 t800
    The status should be failure
    The output should eq "run --rm -it --user $(id -u):$(id -g) -v $TEST_TMP_DIR/t800/build:/home/coreboot/cb_build -v $TEST_TMP_DIR/t800:/home/coreboot/scripts -v $TEST_TMP_DIR/common:/home/coreboot/common_scripts -v $TEST_TMP_DIR/t800/stock_bios:/home/coreboot/stock_bios/:ro -e COREBOOT_COMMIT=abc123 -e COREBOOT_TAG= -e COREBOOT_CONFIG= coreboot/coreboot-sdk:12345 /home/coreboot/scripts/compile.sh"
  End

  It "test with valid model and tag flag"
    cd "$TEST_TMP_DIR" || exit
    When run source "$PROJECT_PATH/build.sh" --tag tag_xyz t800
    The status should be failure
    The output should eq "run --rm -it --user $(id -u):$(id -g) -v $TEST_TMP_DIR/t800/build:/home/coreboot/cb_build -v $TEST_TMP_DIR/t800:/home/coreboot/scripts -v $TEST_TMP_DIR/common:/home/coreboot/common_scripts -v $TEST_TMP_DIR/t800/stock_bios:/home/coreboot/stock_bios/:ro -e COREBOOT_COMMIT= -e COREBOOT_TAG=tag_xyz -e COREBOOT_CONFIG= coreboot/coreboot-sdk:12345 /home/coreboot/scripts/compile.sh"
  End

  It "test with valid model and bleeding edge flag"
    cd "$TEST_TMP_DIR" || exit
    When run source "$PROJECT_PATH/build.sh" --bleeding-edge t800
    The status should be failure
    The output should eq "run --rm -it --user $(id -u):$(id -g) -v $TEST_TMP_DIR/t800/build:/home/coreboot/cb_build -v $TEST_TMP_DIR/t800:/home/coreboot/scripts -v $TEST_TMP_DIR/common:/home/coreboot/common_scripts -v $TEST_TMP_DIR/t800/stock_bios:/home/coreboot/stock_bios/:ro -e COREBOOT_COMMIT=master -e COREBOOT_TAG= -e COREBOOT_CONFIG= coreboot/coreboot-sdk:12345 /home/coreboot/scripts/compile.sh"
  End


  It "test with valid model and unknown flag"
    cd "$TEST_TMP_DIR" || exit
    When run source "$PROJECT_PATH/build.sh" --unknown t800
    The status should be failure
    The line 1 of stderr should eq "Error: Unknown option: --unknown"
    The line 2 of stderr should eq "Usage: "
    The line 3 of stderr should eq ""
    The line 4 of stderr should eq "  $0 [-t <TAG>] [-c <COMMIT>] [--config] [--bleeding-edge] [--clean-slate] <model>"
    The line 5 of stderr should eq ""
    The line 6 of stderr should eq "  --bleeding-edge              Build from the latest commit"
    The line 7 of stderr should eq "  --clean-slate                Purge previous build directory and config"
    The line 8 of stderr should eq "  -c, --commit <commit>        Git commit hash"
    The line 9 of stderr should eq "  --flash                      Flash BIOS if build is successful"
    The line 10 of stderr should eq "  -h, --help                   Show this help"
    The line 11 of stderr should eq "  -i, --config                 Execute with interactive make config"
    The line 12 of stderr should eq "  -t, --tag <tag>              Git tag/version"
    The line 13 of stderr should eq ""
    The line 14 of stderr should eq "If a tag, commit or bleeding-edge flag is not given, the latest Coreboot release will be built."
    The line 15 of stderr should eq ""
    The line 16 of stderr should eq ""
    The line 17 of stderr should eq "Available models:"
    The line 18 of stderr should eq "$(printf '\t')t1000"
    The line 19 of stderr should eq "$(printf '\t')t800"
  End


  It "test with valid model and bleeding edge and config flag"
    cd "$TEST_TMP_DIR" || exit
    When run source "$PROJECT_PATH/build.sh" --bleeding-edge -i t800
    The status should be failure
    The output should eq "run --rm -it --user $(id -u):$(id -g) -v $TEST_TMP_DIR/t800/build:/home/coreboot/cb_build -v $TEST_TMP_DIR/t800:/home/coreboot/scripts -v $TEST_TMP_DIR/common:/home/coreboot/common_scripts -v $TEST_TMP_DIR/t800/stock_bios:/home/coreboot/stock_bios/:ro -e COREBOOT_COMMIT=master -e COREBOOT_TAG= -e COREBOOT_CONFIG=true coreboot/coreboot-sdk:12345 /home/coreboot/scripts/compile.sh"
  End

  It "test with only valid model and flash after build flag"
    cd "$TEST_TMP_DIR" || exit
    echo "echo flashing" > "$TEST_TMP_DIR/flash.sh"
    chmod +x "$TEST_TMP_DIR/flash.sh"
    When run source "$PROJECT_PATH/build.sh" --flash t800
    The line 1 of output should eq "run --rm -it --user $(id -u):$(id -g) -v $TEST_TMP_DIR/t800/build:/home/coreboot/cb_build -v $TEST_TMP_DIR/t800:/home/coreboot/scripts -v $TEST_TMP_DIR/common:/home/coreboot/common_scripts -v $TEST_TMP_DIR/t800/stock_bios:/home/coreboot/stock_bios/:ro -e COREBOOT_COMMIT= -e COREBOOT_TAG= -e COREBOOT_CONFIG= coreboot/coreboot-sdk:12345 /home/coreboot/scripts/compile.sh"
    The line 2 of output should eq "flashing"
    rm "$TEST_TMP_DIR/flash.sh"
  End

  AfterAll
    rmdir "$TEST_TMP_DIR/t800/build"
    rmdir "$TEST_TMP_DIR/t800/stock_bios"
    rmdir "$TEST_TMP_DIR/t800"
    rmdir "$TEST_TMP_DIR/t1000"
    rmdir "$TEST_TMP_DIR"
  export UNIT_TESTING=0
End
