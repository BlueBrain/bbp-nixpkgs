{ fetchgitExternal, stdenv, boost, cmake, hdf5-cpp, pkgconfig, gsl, bbpsdk }:

stdenv.mkDerivation rec {
  name = "bluejittersdk-${version}";
  version = "34c9e";
  buildInputs = [ stdenv boost cmake hdf5-cpp pkgconfig gsl bbpsdk ];

  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/platform/BlueJitterSDK";
    rev = "e9f0b2e2c8b8061995b233d2d2fac5d093034c9e";
    sha256 = "0l95m2rh071rkcmfsg9drcsmhxg7q2j1f9gv9qpqapk8c2f6kbf3";
  }; 


  patches = [ ./patch_cpp11.patch ./bbpsdk_dep.patch ];

  cmakeFlags = [ "-DCOMMON_PACKAGE_USE_QUIET=FALSE" ];

}
