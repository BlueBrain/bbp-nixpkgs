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
  version = "0.26-2017.02";
  buildInputs = [ stdenv pkgconfig boost brion vmmlib servus mvdtool cmake lunchbox python hdf5 doxygen];

  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/common/BBPSDK";
    rev= "d29ddfc872896d94da992f09ae90a7e422f95cda";
    sha256 = "0v4qrkk2dz2byxvbdp2dyi3jsqs0j99q39vydb3890q95z61jqvx";
  };


  # BBPSDK boost.python bindings take more than 1G mem per core to compile
  # with recent GCC, disable parallel buildings or GCC SIGBUS
  enableParallelBuilding = false;


  propagatedBuildInputs = [ brion lunchbox ];
  
}

