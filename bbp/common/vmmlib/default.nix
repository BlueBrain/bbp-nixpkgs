{ stdenv, fetchgit, cmake, doxygen }:

stdenv.mkDerivation rec {
  name = "vmmlib-${version}";
  version = "1.13.0-201708";

  buildInputs = [ stdenv cmake doxygen];

  src = fetchgit {
    url = "https://github.com/Eyescale/vmmlib.git";
    rev= "f4b3706087411c745900e452b645cd357323d398";
    sha256 = "0cnmqqraj752lh8jf2l5fs8b0vc84npvvmk18pmc3x0hrc5ywbpy";
  };


  enableParallelBuilding = true;
}


