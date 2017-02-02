{ stdenv, fetchgitPrivate, cmake, pkgconfig, bison, flex, python }:

stdenv.mkDerivation rec {
  name = "mod2c-${version}";
  version = "2.1.0-201610";
  
  buildInputs = [ stdenv cmake pkgconfig bison flex python];


  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/mod2c";
    rev = "7f2ca8ee1fcba245ad1f7d43ae744851c5915920";
    sha256 = "0byar5xglcilg3n29y8cfsajpvv0fla5z009gwxw2yhiaasyyzp8";
  };
   
  
}


