{ stdenv, fetchgit, cmake, bbp-cmake, doxygen, python, blas  }:

stdenv.mkDerivation rec {
  name = "vmmlib-1.8.0";
  buildInputs = [ stdenv cmake bbp-cmake doxygen python blas];

  src = fetchgit {
    url = "https://github.com/Eyescale/vmmlib.git";
    rev= "67e94ce8c7344b5e42d9ee5f965e9c734c8d8bf8";
    sha256 = "0hj5j5njmwajna7r5qq9dzjncfb2scdx3p22jcsxqa8514c5ivlx";
  };
  
  
  patchPhase= ''
	ln -s ${bbp-cmake}/share/bbp-cmake/Common CMake/common && 
	sed 's@include(Buildyard)@@g' -i CMakeLists.txt &&
	sed 's@include(CPackConfig)@@g' -i CMakeLists.txt	
  '';
    

  enableParallelBuilding = true;
}


