{ stdenv, boost, fetchgit, cmake, servus, pkgconfig, leveldb, doxygen }:

stdenv.mkDerivation rec {
  name = "lunchbox";
  version = "1.16.0-dev201708";
  buildInputs = [ stdenv boost pkgconfig servus cmake leveldb doxygen];

  src = fetchgit {
    url = "https://github.com/Eyescale/Lunchbox.git";
    rev = "80c14e04666aeb64eb69c605663b3065252339c5 ";
    sha256 = "0y4ygxrrvil3p34wppiqc08q3abpjk83fcz2pmsqrcz61x4vvmji";
  };
 

  cmakeFlags = [ "-DCOMMON_DISABLE_WERROR=TRUE" ];


  propagatedBuildInputs = [ boost servus ];


  enableParallelBuilding = true;
  
}



