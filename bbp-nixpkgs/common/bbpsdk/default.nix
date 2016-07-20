{ stdenv, fetchgitExternal, boost, lunchbox, brion, vmmlib, servus, cmake,  pkgconfig, python, hdf5, doxygen }:

stdenv.mkDerivation rec {
  name = "bbpsdk-0.25";
  buildInputs = [ stdenv pkgconfig boost brion vmmlib servus cmake lunchbox python hdf5 doxygen];

  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/common/BBPSDK";
    rev= "b56d8a0cc18fb92d0c0579bce03ff21e61c174bb";
    sha256 = "1wr1yflbzs7lb6jcw4x5ka2im3rvj22zkw7011n58y091qvhydp8";
  };


  # BBPSDK boost.python bindings take more than 1G mem per core to compile
  # with recent GCC, disable parallel buildings or GCC SIGBUS
  enableParallelBuilding = false;
  
}

