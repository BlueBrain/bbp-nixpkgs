{ stdenv
, fetchgitPrivate
, boost
, lunchbox
, brion
, vmmlib
, servus
, mvdtool 
, cmake
, pkgconfig
, python
, hdf5
, doxygen }:

stdenv.mkDerivation rec {
  name = "bbpsdk-${version}";
  version = "0.26-2017.06";
  buildInputs = [ stdenv pkgconfig boost brion vmmlib servus mvdtool cmake lunchbox python hdf5 doxygen];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/common/BBPSDK";
    rev= "f78b366";
    sha256 = "0lx5xgv0q18ib0zj84px0cfs582b0wivai69rdpww53krvbhmicb";
  };


  # BBPSDK boost.python bindings take more than 1G mem per core to compile
  # with recent GCC, disable parallel buildings or GCC SIGBUS
  enableParallelBuilding = false;


  propagatedBuildInputs = [ brion lunchbox ];
  
}

