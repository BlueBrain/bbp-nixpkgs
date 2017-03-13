{ fetchgitExternal, stdenv, boost, cmake, pkgconfig, gsl, bbpsdk, hdf5-cpp, zlib, which }:

stdenv.mkDerivation rec {
  name = "bluerepairsdk-${version}";
  version = "1.0.0";
  buildInputs = [ stdenv boost cmake pkgconfig gsl bbpsdk hdf5-cpp zlib which ];

  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/platform/BlueRepairSDK";
    rev = "c47a778bd8f6b55dbb646ba14f0ab283e138b6cd";
    sha256 = "15l4wzkx5d07wm0g0x0bdhq1m5xrsjl9d2yyq1y119r4r9ipj4k8";
    subdir = "BlueRepairSDK";
  };

  preConfigure = ''
    cd BlueRepairSDK;
    export NIX_CFLAGS_COMPILE=" $NIX_CFLAGS_COMPILE -Wno-error"
  '';

  patches = [ 
        ./0001-Fix-API-break-issue-with-last-version-of-vmmlib.patch
        ./0001-Remove-hardcoded-path-for-h5diff-inside-test-to-make.patch
        ];

  doCheck = false;
  preCheck = ''
    cd ../..
  '';
  checkTarget = "test";
}
