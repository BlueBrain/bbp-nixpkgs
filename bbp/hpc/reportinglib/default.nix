{ stdenv
, config
, fetchgitPrivate
, cmake
, boost
, pkgconfig
, mpiRuntime}:

stdenv.mkDerivation rec {
  name = "reportinglib-${version}";
  version = "2.4.2-2017.07";


  buildInputs = [ stdenv cmake boost pkgconfig  mpiRuntime];


  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/sim/reportinglib/bbp";
    rev = "00e043ead84e8db038df37c115044492e2179d4f";
    sha256 = "0cbzzqr7dprqwff9y7a306q1h6k9vqzb70ck313w7fj6hkrn78i1";
  };



}


