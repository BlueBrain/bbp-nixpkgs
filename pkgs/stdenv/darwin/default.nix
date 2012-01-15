{stdenv, pkgs}:

import ../generic {
  name = "stdenv-darwin";
  preHook = ./prehook.sh;
  initialPath = (import ../common-path.nix) {pkgs = pkgs;};

  system = stdenv.system;

  gcc = import ../../build-support/gcc-wrapper {
    nativeTools = false;
    nativeLibc = true;
    inherit stdenv;
    binutils = import ../../build-support/native-darwin-cctools-wrapper {inherit stdenv;};
    gcc = pkgs.gccApple.gcc;
    coreutils = pkgs.coreutils;
    shell = pkgs.bash + "/bin/sh";
  };

  shell = pkgs.bash + "/bin/sh";

  fetchurlBoot = stdenv.fetchurlBoot;
}
