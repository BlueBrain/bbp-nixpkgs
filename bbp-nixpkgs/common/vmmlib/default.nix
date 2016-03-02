{ stdenv, fetchgit, cmake, cmake-external, doxygen, python, blas  }:

stdenv.mkDerivation rec {
  name = "vmmlib-1.8.0-DEV";
  buildInputs = [ stdenv cmake cmake-external doxygen python blas];

  src = fetchgit {
    url = "https://github.com/Eyescale/vmmlib.git";
    rev= "b41e1a5574bf6405a5076d4e5c9c27c73dea96d3";
    sha256 = "1gxydlj5a5ajkgwij7qh4hk7fw940524mkd699vwxkmfibaj9nyx";
    leaveDotGit = true;
  };
  
  
  patchPhase= ''
	sed 's@include(Buildyard)@@g' -i CMakeLists.txt &&
	sed 's@include(CPackConfig)@@g' -i CMakeLists.txt	
  '';
    

  enableParallelBuilding = true;
}


