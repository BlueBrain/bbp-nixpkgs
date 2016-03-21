{ stdenv, fetchgitPrivate, cmake, blas, liblapack, python, swig, numpy, mpiRuntime, gtest }:

stdenv.mkDerivation rec {
  name = "steps-2.2.1-unstable";
  buildInputs = [ stdenv cmake blas liblapack mpiRuntime python numpy swig numpy gtest ];

  src = fetchgitPrivate {
    url = "ssh://git@github.com/CNS-OIST/HBP_STEPS.git";
    rev = "c64ca8b6a2d65f54b3e090820a319215412b936c";
    sha256 = "1z4wk1mph76pvvdyxcr222a0fnjfh98igapddnr2qy7bkm98c8hn";
  };
  
  patches = [
                ./gtest-patch.patch
            ];

  enableParallelBuilding = true;

  CXXFLAGS="-pthread ";
  
  cmakeFlags = [ "-DGTEST_USE_EXTERNAL=TRUE" ];
 
  
}


