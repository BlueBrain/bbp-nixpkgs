{ stdenv, fetchgitPrivate, cmake, pkgconfig, bison, flex, python }:

stdenv.mkDerivation rec {
  name = "mod2c-${version}";
  version = "2.1.0-201610";
  
  buildInputs = [ stdenv cmake pkgconfig bison flex python];


  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/mod2c";
    rev = "babfe2cafaa5961b56d7515e88752d8f9607e11f";
    sha256 = "1qqml8d7h9q3wv089qcpqkjn25rwdxligm6zd48bk7cqlh9lnsc6";
  };
   
  
}


