{ stdenv, fetchgitPrivate, pkgconfig, boost, hpctools, libxml2, cmake, mpiRuntime, zlib, python, hdf5, doxygen }:

stdenv.mkDerivation rec {
  name = "functionalizer-3.6.0-DEV";
  buildInputs = [ stdenv pkgconfig boost hpctools zlib cmake mpiRuntime libxml2 python hdf5 doxygen];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/Functionalizer";
    rev = "182addb2847d4fc401df0e13f81fdbf32c8f1ac1";
    sha256 = "14ffyqxb9q1hy532ibssw2sxmkqc57j8v71l62bf85gd50yiz48f";
  };
  
  cmakeFlags="-DBoost_USE_STATIC_LIBS=FALSE -DUNIT_TESTS=TRUE";   

  enableParallelBuilding = true;
 
  
}


