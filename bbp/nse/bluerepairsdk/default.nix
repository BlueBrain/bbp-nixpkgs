{ fetchgitExternal
, config
, stdenv
, boost
, cmake
, pkgconfig
, gsl
, bbpsdk
, hdf5-cpp
, zlib
, which }:

stdenv.mkDerivation rec {
  name = "bluerepairsdk-${version}";
  version = "1.0.0";
  buildInputs = [ stdenv boost cmake pkgconfig gsl bbpsdk hdf5-cpp zlib which ];

  src = fetchgitExternal {
    url = config.bbp_git_ssh + "/platform/BlueRepairSDK";
    rev = "58cf1c9e37226142fbc214f6a4fa3f8e35a8385a";
    sha256 = "132q3zyjb4aaz244j2qarpwg6xv3jqq5mfsl1qniy4s7fdj9axqd";
    subdir = "BlueRepairSDK";
  };

  preConfigure = ''
    cd BlueRepairSDK;
    export NIX_CFLAGS_COMPILE=" $NIX_CFLAGS_COMPILE -Wno-error"
  '';

  doCheck = true;
  preCheck = ''
    cd ../..
  '';
  checkTarget = "test";
}
