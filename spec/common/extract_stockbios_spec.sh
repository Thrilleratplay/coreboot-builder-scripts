#!/bin/sh

Describe "extract_stockbios.sh"
  Describe "buildIfdtool"
    PROJECT_PATH=$(realpath .)
    TEST_TMP_DIR="$PROJECT_PATH/spec/test_tmp"
    TEST_TMP_IFDTOOL_DIR="$TEST_TMP_DIR/util/ifdtool"

    BeforeAll
      mkdir -p "$TEST_TMP_DIR" || true
      mkdir -p "$TEST_TMP_IFDTOOL_DIR" || true

    cd() {
      echo "cd called with parameters:"
      echo "$@"
    }

    make() {
      echo "make called with parameters:"
      echo "$@"
    }

    chmod() {
      echo "chmod called with parameters:"
      echo "$@"
    }

    export UNIT_TESTING=1

    export DOCKER_COREBOOT_DIR=$TEST_TMP_DIR

    Include "./common/extract_stockbios.sh"

    It "test BuildIfdTool"
      When call buildIfdtool
      The line 1 of output should eq "cd called with parameters:"
      The line 2 of output should eq "$TEST_TMP_IFDTOOL_DIR"
      The line 3 of output should eq "make called with parameters:"
      The line 4 of output should eq ""
      The line 5 of output should eq "chmod called with parameters:"
      The line 6 of output should eq "+x ifdtool"
    End

    AfterAll
      rmdir "$TEST_TMP_IFDTOOL_DIR"
      rmdir "$TEST_TMP_DIR/util"
      rmdir "$TEST_TMP_DIR"
      export UNIT_TESTING=0
  End

  Describe "extractStockBios"
    PROJECT_PATH=$(realpath .)
    TEST_TMP_DIR="$PROJECT_PATH/spec/test_tmp"
    TEST_TMP_STOCK_BIOS_DIR="$TEST_TMP_DIR/stock_bios"

    BeforeAll
      mkdir -p "$TEST_TMP_DIR" || true
      mkdir -p "$TEST_TMP_STOCK_BIOS_DIR" || true

    cd() {
      echo "cd called with parameters:"
      echo "$@"
    }

    cp() {
      echo "cp called with parameters:"
      echo "$@"
    }

    sh() {
      echo "sh called with parameters:"
      echo "$@"
    }

    mv() {
      echo "mv called with parameters:"
      echo "$@"
    }

    rm() {
      echo "rm called with parameters:"
      echo "$@"
    }

    export UNIT_TESTING=1

    export DOCKER_COREBOOT_DIR=$TEST_TMP_DIR
    export DOCKER_STOCK_BIOS_DIR=$TEST_TMP_STOCK_BIOS_DIR
    export STOCK_BIOS_ROM="fakeStockBios.bin"

    Include "./common/extract_stockbios.sh"

    buildIfdtool() {
      echo "buildIfdtool was called"
    }

    It "test extractStockBios with no parameters"
      When run extractStockBios
      The stderr should eq "extractStockBios is missing the MAINBOARD, MODEL and STOCK_BIOS_ROM parameters."
      The status should be failure
    End

    It "test extractStockBios with one parameter"
      When run extractStockBios fakeMainboard
      The stderr should eq "extractStockBios is missing the MODEL and STOCK_BIOS_ROM parameters."
      The status should be failure
    End

    It "test extractStockBios with two parameters"
      When run extractStockBios fakeMainboard fakeModel
      The stderr should eq "extractStockBios is missing the STOCK_BIOS_ROM parameter."
      The status should be failure
    End

    It "test extractStockBios fails if stockbios file is not found"
      When run extractStockBios fakeMainboard fakeModel $STOCK_BIOS_ROM
      The stderr should eq "Cannot find $STOCK_BIOS_ROM."
      The status should be failure
    End

    It "test extractStockBios fails if stockbios file is not found"
      When run extractStockBios fakeMainboard fakeModel $STOCK_BIOS_ROM
      The stderr should eq "Cannot find $STOCK_BIOS_ROM."
      The status should be failure
    End

    It "test extractStockBios fails if stockbios file is not found"
      When run extractStockBios fakeMainboard fakeModel $STOCK_BIOS_ROM
      The stderr should eq "Cannot find $STOCK_BIOS_ROM."
      The status should be failure
    End

    Before
      touch "$TEST_TMP_STOCK_BIOS_DIR/$STOCK_BIOS_ROM"
      mkdir -p "$TEST_TMP_DIR/util/ifdtool"
    #   mkdir -p "$TEST_TMP_DIR/3rdparty/blobs/mainboard/fakeMainboard/fakeModel/"

    It "test extractStockBios fails if stockbios file is not found"
      When run extractStockBios fakeMainboard fakeModel $STOCK_BIOS_ROM
      The line 1 of output should eq "buildIfdtool was called"
      The line 2 of output should eq "cd called with parameters:"
      The line 3 of output should eq "$TEST_TMP_DIR/3rdparty/blobs/mainboard/fakeMainboard/fakeModel/"
      The line 4 of output should eq "cp called with parameters:"
      The line 5 of output should eq "/data/projects/coreboot-builder-scripts/spec/test_tmp/util/ifdtool/ifdtool ."
      The line 6 of output should eq "cp called with parameters:"
      The line 7 of output should eq "/data/projects/coreboot-builder-scripts/spec/test_tmp/stock_bios/fakeStockBios.bin ."
      The line 8 of output should eq "sh called with parameters:"
      The line 9 of output should eq "ifdtool -u fakeStockBios.bin"
      The line 10 of output should eq "sh called with parameters:"
      The line 11 of output should eq "ifdtool -x fakeStockBios.bin"
      The line 12 of output should eq "mv called with parameters:"
      The line 13 of output should eq "flashregion_0_flashdescriptor.bin descriptor.bin"
      The line 14 of output should eq "mv called with parameters:"
      The line 15 of output should eq "flashregion_2_intel_me.bin me.bin"
      The line 16 of output should eq "mv called with parameters:"
      The line 17 of output should eq "flashregion_3_gbe.bin gbe.bin"
      The line 18 of output should eq "rm called with parameters:"
      The line 19 of output should eq "ifdtool"
      The line 20 of output should eq "rm called with parameters:"
      The line 21 of output should eq "flashregion_1_bios.bin"
    End

    AfterAll
      unset rm
      rm "$TEST_TMP_STOCK_BIOS_DIR/$STOCK_BIOS_ROM"
      rmdir -p --ignore-fail-on-non-empty "$TEST_TMP_STOCK_BIOS_DIR"
      rmdir -p --ignore-fail-on-non-empty "$TEST_TMP_DIR/util/ifdtool/"
      rmdir -p --ignore-fail-on-non-empty "$TEST_TMP_DIR/3rdparty/blobs/mainboard/fakeMainboard/fakeModel/"
      export UNIT_TESTING=0
  End
End