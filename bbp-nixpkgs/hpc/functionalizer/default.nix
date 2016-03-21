{ stdenv, fetchgitPrivate, pkgconfig, boost, hpctools, libxml2, cmake, mpiRuntime, zlib, python, hdf5, doxygen }:

stdenv.mkDerivation rec {
  name = "functionalizer-3.6.0-DEV";
  buildInputs = [ stdenv pkgconfig boost hpctools zlib cmake mpiRuntime libxml2 python hdf5 doxygen];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/Functionalizer";
    rev = "388fb479fa261231d0ecde9b64020e5e1027dea8";
    sha256 = "0bzq3097j56sa3x5xnbi3a4nrflyh0nqrb3877qc91zlnsvsp7ld";
  };
  
  cmakeFlags="-DBoost_USE_STATIC_LIBS=FALSE -DUNIT_TESTS=TRUE";   

  enableParallelBuilding = true;
 
  
}


