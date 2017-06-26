{ stdenv, fetchgitPrivate, cmake, boost, pkgconfig, mpiRuntime}:

stdenv.mkDerivation rec {
  name = "reportinglib-${version}";
  version = "2.4.2-2017.06";


  buildInputs = [ stdenv cmake boost pkgconfig  mpiRuntime];


  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/reportinglib/bbp";
    rev = "b421d92a22cd2bd92e66768f9fb2691ca62d722d";
    sha256 = "07f7067h6iialbv6la01i6civhfdv1md9bn7lfdd7hkmszbd9psw";
  };
  
  
 
}


