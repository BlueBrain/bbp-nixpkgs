{ fetchgitExternal, stdenv, boost, cmake, pkgconfig, bbpsdk, hdf5 }:

stdenv.mkDerivation rec {
  name = "MorphScale-${version}";
  version = "0.0.1";
  buildInputs = [ stdenv boost cmake pkgconfig bbpsdk hdf5];

  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/platform/MorphScale";
    rev = "e4f232404692a50e73675edb0d4a0a5e7244555e";
    sha256 = "1sr3hygsy7mnzxmh1330nz3rpxzffva6ygf3zac2dp7c9yglf5kd";
  };

  doCheck = true;
  preCheck = ''
    pushd . && cd ..
  '';
  checkTarget = "test";
  postCheck = ''
    popd
  '';
}
