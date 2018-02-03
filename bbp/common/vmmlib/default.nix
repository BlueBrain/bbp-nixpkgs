{ stdenv, fetchgit, cmake, doxygen }:

stdenv.mkDerivation rec {
  name = "vmmlib-${version}";
  version = "1.13.0-201801";

  buildInputs = [ stdenv cmake doxygen];

  src = fetchgit {
    url = "https://github.com/Eyescale/vmmlib.git";
    rev= "d7681fec9ee1bd28c429eef5287c672a7dba39bf";
    sha256 = "1q3gb2ba07w28rgdrncv2fjwklbpk5gjnbmw99ld61285jng8dcf";
  };


  enableParallelBuilding = true;
}


