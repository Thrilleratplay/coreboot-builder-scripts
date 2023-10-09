#!/bin/sh

Describe "download_coreboot.sh"
  PROJECT_PATH=$(realpath .)
  TEST_TMP_DIR="$PROJECT_PATH/spec/test_tmp"

  export UNIT_TESTING=1

  BeforeAll
    mkdir -p "$TEST_TMP_DIR" || true
    export DOCKER_COREBOOT_DIR=$TEST_TMP_DIR

  cd() {
    echo "cd called with parameters:"
    echo "$@"
  }

  git() {
    echo "git called with parameters:"
    echo "$@"
  }

  wget() {
    echo "wget called with parameters:"
    echo "$@"
  }

  unxz() {
    echo "unxz called with parameters:"
    echo "$@"
  }

  tar() {
    echo "tar called with parameters:"
    echo "$@"
  }

  Include "./common/download_coreboot.sh"

  Describe "gitUpdate"
    It "clones the git repo if the directory is empty"
      When call gitUpdate
      The line 1 of output should eq "git called with parameters:"
      The line 2 of output should eq "clone https://github.com/coreboot/coreboot.git $TEST_TMP_DIR"
      The line 3 of output should eq "cd called with parameters:"
      The line 4 of output should eq "$TEST_TMP_DIR"
      The line 5 of output should eq "git called with parameters:"
      The line 6 of output should eq "submodule update --init --recursive --remote"
      The line 7 of output should eq "git called with parameters:"
      The line 8 of output should eq "clone https://github.com/coreboot/blobs.git 3rdparty/blobs/"
      The line 9 of output should eq "git called with parameters:"
      The line 10 of output should eq "clone https://github.com/coreboot/intel-microcode.git 3rdparty/intel-microcode/"
    End



    ls() {
      echo "a"
    }
    Include "./common/download_coreboot.sh"

    It "updates the git repo if the directory is not empty"
      When call gitUpdate
      The line 1 of output should eq "cd called with parameters:"
      The line 2 of output should eq "$TEST_TMP_DIR"
      The line 3 of output should eq "git called with parameters:"
      The line 4 of output should eq "fetch --all --tags --prune"
      The line 5 of output should eq "git called with parameters:"
      The line 6 of output should eq "clone https://github.com/coreboot/intel-microcode.git 3rdparty/intel-microcode/"
      The line 7 of output should eq "cd called with parameters:"
      The line 8 of output should eq "$TEST_TMP_DIR/3rdparty/blobs/"
      The line 9 of output should eq "git called with parameters:"
      The line 10 of output should eq "fetch --all --tags --prune"
      The line 11 of output should eq "cd called with parameters:"
      The line 12 of output should eq "$TEST_TMP_DIR/3rdparty/intel-microcode/"
      The line 13 of output should eq "git called with parameters:"
      The line 14 of output should eq "fetch --all --tags --prune"
    End
  End


  Describe "checkoutTag"
    It "checkout git repo by tag"
      export COREBOOT_TAG="some_tag"

      When call checkoutTag
      The line 1 of output should eq "cd called with parameters:"
      The line 2 of output should eq "$TEST_TMP_DIR"
      The line 3 of output should eq "git called with parameters:"
      The line 4 of output should eq "checkout tags/some_tag"
      The line 5 of output should eq "git called with parameters:"
      The line 6 of output should eq "submodule update --recursive --remote"
    End
  End

  Describe "checkoutCommit"
    It "checkout git repo by commit"
      export COREBOOT_COMMIT="some_commit"

      When call checkoutCommit
      The line 1 of output should eq "cd called with parameters:"
      The line 2 of output should eq "$TEST_TMP_DIR"
      The line 3 of output should eq "git called with parameters:"
      The line 4 of output should eq "checkout some_commit"
      The line 5 of output should eq "git called with parameters:"
      The line 6 of output should eq "submodule update --recursive --remote"
    End

    It "checkout git repo by main commit"
      export COREBOOT_COMMIT="main"

      When call checkoutCommit
      The line 1 of output should eq "cd called with parameters:"
      The line 2 of output should eq "$TEST_TMP_DIR"
      The line 3 of output should eq "git called with parameters:"
      The line 4 of output should eq "checkout main"
      The line 5 of output should eq "git called with parameters:"
      The line 6 of output should eq "pull --all"
      The line 7 of output should eq "git called with parameters:"
      The line 8 of output should eq "submodule update --recursive --remote"
    End
  End

  Describe "downloadCoreboot"
    It "downloads coreboot by version"
      When call downloadCoreboot
      The line 1 of output should eq "Beginning download of ..."
      The line 2 of output should eq "tar called with parameters:"
      The line 3 of output should eq "-C $TEST_TMP_DIR -x --strip 1"
      The line 4 of output should eq "tar called with parameters:"
      The line 5 of output should eq "-C $TEST_TMP_DIR -x --strip 1"
      The line 6 of output should eq "Downloading  complete"
    End
  End


  Describe "downloadOrUpdateCoreboot"
    It "download lastest Coreboot"
      export COREBOOT_TAG=""
      When call downloadOrUpdateCoreboot
      The line 1 of output should eq "Beginning download of ..."
      The line 2 of output should eq "tar called with parameters:"
      The line 3 of output should eq "-C $TEST_TMP_DIR -x --strip 1"
      The line 4 of output should eq "tar called with parameters:"
      The line 5 of output should eq "-C $TEST_TMP_DIR -x --strip 1"
      The line 6 of output should eq "Downloading  complete"
    End

    It "download Coreboot by tag"
      export COREBOOT_TAG="some_tag"
      When call downloadOrUpdateCoreboot
      The line 1 of output should eq "git called with parameters:"
      The line 2 of output should eq "clone https://github.com/coreboot/coreboot.git $TEST_TMP_DIR"
      The line 3 of output should eq "cd called with parameters:"
      The line 4 of output should eq "$TEST_TMP_DIR"
      The line 5 of output should eq "git called with parameters:"
      The line 6 of output should eq "submodule update --init --recursive --remote"
      The line 7 of output should eq "git called with parameters:"
      The line 8 of output should eq "clone https://github.com/coreboot/blobs.git 3rdparty/blobs/"
      The line 9 of output should eq "git called with parameters:"
      The line 10 of output should eq "clone https://github.com/coreboot/intel-microcode.git 3rdparty/intel-microcode/"
      The line 11 of output should eq "cd called with parameters:"
      The line 12 of output should eq "$TEST_TMP_DIR"
      The line 13 of output should eq "git called with parameters:"
      The line 14 of output should eq "checkout tags/some_tag"
      The line 15 of output should eq "git called with parameters:"
      The line 16 of output should eq "submodule update --recursive --remote"
    End

    It "download Coreboot by commit"
      export COREBOOT_COMMIT="some_commit"
      When call downloadOrUpdateCoreboot
      The line 1 of output should eq "git called with parameters:"
      The line 2 of output should eq "clone https://github.com/coreboot/coreboot.git $TEST_TMP_DIR"
      The line 3 of output should eq "cd called with parameters:"
      The line 4 of output should eq "$TEST_TMP_DIR"
      The line 5 of output should eq "git called with parameters:"
      The line 6 of output should eq "submodule update --init --recursive --remote"
      The line 7 of output should eq "git called with parameters:"
      The line 8 of output should eq "clone https://github.com/coreboot/blobs.git 3rdparty/blobs/"
      The line 9 of output should eq "git called with parameters:"
      The line 10 of output should eq "clone https://github.com/coreboot/intel-microcode.git 3rdparty/intel-microcode/"
      The line 11 of output should eq "cd called with parameters:"
      The line 12 of output should eq "$TEST_TMP_DIR"
      The line 13 of output should eq "git called with parameters:"
      The line 14 of output should eq "checkout some_commit"
      The line 15 of output should eq "git called with parameters:"
      The line 16 of output should eq "submodule update --recursive --remote"
    End
  End

  AfterAll
    rmdir "$TEST_TMP_DIR"
    export UNIT_TESTING=0
End
