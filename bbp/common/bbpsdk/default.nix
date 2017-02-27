{ stdenv
, fetchgitExternal
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
  version = "0.25";
  buildInputs = [ stdenv pkgconfig boost brion vmmlib servus mvdtool cmake lunchbox python hdf5 doxygen];

  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/common/BBPSDK";
    rev= "bbf564e45237573ce860bcc68d92fdd0f5e09930";
    sha256 = "1zaiavabx5j2xqiwyybrr046v829wxkyi5k4adrr5inlzjgzm0n8";
  };


  # BBPSDK boost.python bindings take more than 1G mem per core to compile
  # with recent GCC, disable parallel buildings or GCC SIGBUS
  enableParallelBuilding = false;


  propagatedBuildInputs = [ brion lunchbox ];
  
}

