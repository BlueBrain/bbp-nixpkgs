{ stdenv, fetchgitPrivate, cmake, cmake-external, pkgconfig, bison, flex, python }:

stdenv.mkDerivation rec {
  name = "mod2c-1.1.1-stable";
  buildInputs = [ stdenv cmake cmake-external pkgconfig bison flex python];


  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/mod2c";
    rev = "2d8cbf240ed6739de6c06a397238e028f61bf307";
    sha256 = "06rc0lrv99hkki57g608kb3bc7vxrv0qvmwbq2a2rl4di721d94w";
    deepClone = true;
  };
   
  
}


