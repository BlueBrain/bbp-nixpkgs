{ stdenv, fetchgitExternal, cmake, pkgconfig, bison, flex, python }:

stdenv.mkDerivation rec {
  name = "mod2c-1.1.1";
  buildInputs = [ stdenv cmake pkgconfig bison flex python];


  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/sim/mod2c";
    rev = "b3bb86294e1fea3d0768291bec9f062db78bc8db";
    sha256 = "0wwjw9225w4cf0mx3z5042y6zjbqimq724hl0pd300bqqlfrsvff";
  };
   
  
}


