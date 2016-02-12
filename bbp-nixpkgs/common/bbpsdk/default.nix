{ stdenv, fetchgitPrivate, boost, lunchbox, brion, vmmlib, servus, cmake, cmake-external, pkgconfig, python, hdf5, doxygen }:

stdenv.mkDerivation rec {
  name = "bbpsdk-0.24.0-DEV";
  buildInputs = [ stdenv pkgconfig boost brion vmmlib servus cmake cmake-external lunchbox python hdf5 doxygen];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/common/BBPSDK";
    rev= "bcd48b43afb3a6fa433bc7f9a5197a605f89a365";
    sha256 = "0qi7dx1i530syhkkm8z0dg36ipbh1x6z9szybs5wf7wvhsf1jh66";
    deepClone = true;
  };

  enableParallelBuilding = true;
  
}

