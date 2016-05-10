{ stdenv, fetchgitPrivate, cmake, blas, liblapack, python, swig, numpy, mpiRuntime, gtest }:

stdenv.mkDerivation rec {
  name = "steps-2.2.1";
  buildInputs = [ stdenv cmake blas liblapack mpiRuntime python numpy swig numpy gtest ];

  src = fetchgitPrivate {
    url = "ssh://git@github.com/CNS-OIST/HBP_STEPS.git";
    rev = "223d346ad08e2839ab6bc2a6b8231eaeb327c9c1";
    sha256 = "19jkk47n2lqck9is0zl25b3g6yswrqcb5gx9vvq80wzcc2jys7wq";
  };
  
  patches = [
                ./gtest-patch.patch
            ];

  enableParallelBuilding = true;

  CXXFLAGS="-pthread ";
  
  cmakeFlags = [ "-DGTEST_USE_EXTERNAL=TRUE" ];
 
  
}


