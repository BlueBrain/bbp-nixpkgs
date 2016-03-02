{ stdenv, fetchgitExternal, cmake, doxygen, python, blas  }:

stdenv.mkDerivation rec {
  name = "vmmlib-1.8.0-DEV";
  buildInputs = [ stdenv cmake doxygen python blas];

  src = fetchgitExternal {
    url = "https://github.com/Eyescale/vmmlib.git";
    rev= "891fce2d5d32c6a3ba3038383067af48081ac33e";
    sha256 = "0vnbcqp11w2niy94600pgaq8vlsn3skaw7bxwjmf5gkcbjjj589m";
  };
  
  
  patchPhase= ''
	sed 's@include(Buildyard)@@g' -i CMakeLists.txt &&
	sed 's@include(CPackConfig)@@g' -i CMakeLists.txt	
  '';
    

  enableParallelBuilding = true;
}


