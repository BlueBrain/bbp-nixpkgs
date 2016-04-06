{ stdenv, fetchgitPrivate, pkgconfig, boost, hpctools, libxml2, cmake, mpiRuntime, zlib, python, hdf5, doxygen }:

stdenv.mkDerivation rec {
  name = "functionalizer-3.6.0-DEV";
  buildInputs = [ stdenv pkgconfig boost hpctools zlib cmake mpiRuntime libxml2 python hdf5 doxygen];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/Functionalizer";
    rev = "2ec8bc2d4563abcc903c908c2c5443f08a3b621e";
    sha256 = "0w3763akdvvfz794vsii61mgylnvmar4ds8xk87fhidaym4jx02m";
  };
  
  cmakeFlags="-DBoost_USE_STATIC_LIBS=FALSE -DUNIT_TESTS=TRUE";   

  enableParallelBuilding = true;
 
  
}


