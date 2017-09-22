{ stdenv
, config
, fetchgitPrivate
, cmake
, boost
, pkgconfig
, mpiRuntime}:

stdenv.mkDerivation rec {
  name = "reportinglib-${version}";
  version = "2.4.2-dev201708";


  buildInputs = [ stdenv cmake boost pkgconfig  mpiRuntime];


  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/sim/reportinglib/bbp";
    rev = "00e043ead84e8db038df37c115044492e2179d4f";
    sha256 = "0sh9j5kyx9gv042vvgr5k1h2a79cndfrhrhq18b0x0cbcr2nbk2s";
  };



}


