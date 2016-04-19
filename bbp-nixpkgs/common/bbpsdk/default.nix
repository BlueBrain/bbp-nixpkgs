{ stdenv, fetchgitExternal, boost, lunchbox, brion, vmmlib, servus, cmake,  pkgconfig, python, hdf5, doxygen }:

stdenv.mkDerivation rec {
  name = "bbpsdk-0.24.0-DEV";
  buildInputs = [ stdenv pkgconfig boost brion vmmlib servus cmake lunchbox python hdf5 doxygen];

  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/common/BBPSDK";
    rev= "809c9ffc3b0f1dcfadd49f651e185540d1a0935f";
    sha256 = "04mv7rxi3ziml041blqi5dlbf7vajd5c8vcw0rylp68lcvm0f4ai";
  };


  # BBPSDK boost.python bindings take more than 1G mem per core to compile
  # with recent GCC, disable parallel buildings or GCC SIGBUS
  enableParallelBuilding = false;
  
}

