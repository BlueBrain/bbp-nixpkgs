{ stdenv, fetchgitPrivate, cmake, pkgconfig, bison, flex, python }:

stdenv.mkDerivation rec {
  name = "mod2c-${version}";
  version = "1.1.1";
  
  buildInputs = [ stdenv cmake pkgconfig bison flex python];


  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/mod2c";
    rev = "1b7adb0ed4b10b0187a505b64768329008f822c5";
    sha256 = "1r710f1lqf7b9wk1wdf0f2asxms157s4y8xcfcfhv611rq5m1835";
  };
   
  
}


