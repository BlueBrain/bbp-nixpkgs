{ stdenv, fetchgitPrivate, cmake, pkgconfig, bison, flex, python }:

stdenv.mkDerivation rec {
  name = "mod2c-${version}";
  version = "2.1.0";
  
  buildInputs = [ stdenv cmake pkgconfig bison flex python];


  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/mod2c";
    rev = "15dcfee880b7e79f0741c86bb7bc3a3b2515b85c";
    sha256 = "09fzjcfhyc6n5jgmbd221xwz72fzmg5xxrsdzs09x1fa4i1cycy6";
  };
   
  
}


