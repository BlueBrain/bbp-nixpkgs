{ stdenv, boost, fetchgit, cmake, servus, pkgconfig, leveldb, doxygen }:

stdenv.mkDerivation rec {
  name = "lunchbox";
  version = "1.16.0";
  buildInputs = [ stdenv boost pkgconfig servus cmake leveldb doxygen];

  src = fetchgit {
    url = "https://github.com/Eyescale/Lunchbox.git";
    rev = "1a96478";
    sha256 = "0igsmr741bfwzq0x5x5li53vwh33233bciryrn2fnkigjj0y9jff";
  };
 

  cmakeFlags = [ "-DCOMMON_DISABLE_WERROR=TRUE" ];


  propagatedBuildInputs = [ boost servus ];


  enableParallelBuilding = true;
  
}



