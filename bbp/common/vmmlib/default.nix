{ stdenv, fetchgit, cmake, doxygen }:

stdenv.mkDerivation rec {
  name = "vmmlib-${version}";
  version = "1.13.0-201708";

  buildInputs = [ stdenv cmake doxygen];

  src = fetchgit {
    url = "https://github.com/Eyescale/vmmlib.git";
    rev= "f4b3706087411c745900e452b645cd357323d398";
    sha256 = "0r3yshnaa075ii0cl6flc4wb74bap5f8gm3l1zv2nqi8nbv1wpbn";
  };


  enableParallelBuilding = true;
}


