{ stdenv, fetchgitPrivate, cmake, blas, liblapack, python, swig, numpy, mpiRuntime, gtest }:

stdenv.mkDerivation rec {
  name = "steps-2.2.1-unstable";
  buildInputs = [ stdenv cmake blas liblapack mpiRuntime python numpy swig numpy gtest ];

  src = fetchgitPrivate {
    url = "ssh://git@github.com/CNS-OIST/HBP_STEPS.git";
    rev = "39345322905fe942f194ddc1aba77bf29ec59f5b";
    sha256 = "10x6y3ad946k213afx1lv9radlqgmrnlf68150rbl0x4ric5kwpj";
  };
  
  patches = [
                ./gtest-patch.patch
            ];

  enableParallelBuilding = true;
  
  cmakeFlags = [ "-DGTEST_USE_EXTERNAL=TRUE" ];
 
  
}


