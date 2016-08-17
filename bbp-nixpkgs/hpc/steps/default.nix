{ stdenv, fetchgitPrivate, cmake, blas, liblapack, python, swig, numpy, petsc, mpiRuntime, gtest }:

stdenv.mkDerivation rec {
  name = "steps-${version}";
  version = "2.2.1";

  nativeBuildInputs = [ cmake swig ];
  
  buildInputs = [ stdenv blas liblapack mpiRuntime petsc python numpy gtest ];

  src = fetchgitPrivate {
    url = "ssh://git@github.com/BlueBrain/HBP_STEPS.git";
    rev = "34715cc7d77c954c0f9a813b61cd70f103d36364";
    sha256 = "1wy8fi6px1bldd31xwmdz69gix624wabnhqk9dh5dz9hp2728k81";
  };
  
  patches = [
    #            ./gtest-patch.patch
            ];

  enableParallelBuilding = true;

  CXXFLAGS="-pthread ";
  
  cmakeFlags = [ "-DGTEST_USE_EXTERNAL=TRUE" ];
 
  
}


