{ fetchgitExternal
, config
, stdenv
, boost
, cmake
, pkgconfig
, bbpsdk
, hdf5 }:

stdenv.mkDerivation rec {
  name = "morphscale-${version}";
  version = "0.0.1";
  buildInputs = [ stdenv boost cmake pkgconfig bbpsdk hdf5];

  src = fetchgitExternal {
    url = config.bbp_git_ssh + "/platform/MorphScale";
    rev = "e4f232404692a50e73675edb0d4a0a5e7244555e";
    sha256 = "17cimnck19wh2s746z426nkxd1aribriqlzwnij15bc8rgadjcn7";
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
