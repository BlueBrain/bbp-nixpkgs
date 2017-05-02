{ stdenv, fetchgitPrivate, cmake, boost, pkgconfig, mpiRuntime}:

stdenv.mkDerivation rec {
  name = "reportinglib-${version}";
  version = "2.4.2-2017.04";


  buildInputs = [ stdenv cmake boost pkgconfig  mpiRuntime];


  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/reportinglib/bbp";
    rev = "69c0739f21e0c6cf218e4179db243bde8f7ad55a";
    sha256 = "18slska48i2bf2vc2iclm54qd0cabjd49fhz0s8q0b9sklpbvdq8";
  };
  
  
 
}


