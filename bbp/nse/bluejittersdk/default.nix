{ fetchgitExternal
, config
, stdenv
, boost
, cmake
, hdf5-cpp
, pkgconfig
, gsl
, bbpsdk }:

stdenv.mkDerivation rec {
  name = "bluejittersdk-${version}";
  version = "34c9e";
  buildInputs = [ stdenv boost cmake hdf5-cpp pkgconfig gsl bbpsdk ];

  src = fetchgitExternal {
    url = config.bbp_git_ssh + "/platform/BlueJitterSDK";
    rev = "e9f0b2e2c8b8061995b233d2d2fac5d093034c9e";
    sha256 = "1gsklk4a1j6vws7kzmwhcgxkdb6lj5mfn3a3hjjpic01sxxipyb1";
  };


  patches = [ ./patch_cpp11.patch ./bbpsdk_dep.patch ];

  cmakeFlags = [ "-DCOMMON_PACKAGE_USE_QUIET=FALSE" ];

}
