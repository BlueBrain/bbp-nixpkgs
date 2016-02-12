{ stdenv, fetchgit, cmake, cmake-external, doxygen, python, blas  }:

stdenv.mkDerivation rec {
  name = "vmmlib-1.8.0-DEV";
  buildInputs = [ stdenv cmake cmake-external doxygen python blas];

  src = fetchgit {
    url = "https://github.com/Eyescale/vmmlib.git";
    rev= "b41e1a5574bf6405a5076d4e5c9c27c73dea96d3";
    sha256 = "0q8w6kg6kgf1g4b2i1cbph1f5l0vyjnz62y3id1i9ja6afahyi1n";
    deepClone = true;
  };
  
  
  patchPhase= ''
	sed 's@include(Buildyard)@@g' -i CMakeLists.txt &&
	sed 's@include(CPackConfig)@@g' -i CMakeLists.txt	
  '';
    

  enableParallelBuilding = true;
}


