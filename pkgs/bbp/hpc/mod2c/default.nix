{ stdenv, fetchgitPrivate, cmake, bbp-cmake, pkgconfig, bison, flex, python }:

stdenv.mkDerivation rec {
  name = "mod2c-1.1.1";
  buildInputs = [ stdenv cmake pkgconfig bison flex python];


  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/mod2c";
    rev = "64ca3ee83bbaf9f80ea14e7f7fb2d9ab34577965";
    sha256 = "1q12ld9jbjd0jhkgjxx9qbvykh2sc00kn14l2347xcjkcl2awckj";
  };
  
  patchPhase= ''
	ln -s ${bbp-cmake}/share/bbp-cmake/Common CMake/common &&
	sed -i 's@include(CommonCPack)@@g' CMakeLists.txt
	'';  
  
}


