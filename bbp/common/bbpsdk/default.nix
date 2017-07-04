{ stdenv
, config
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
    url = config.bbp_git_ssh + "/common/BBPSDK";
    rev= "7ccfd867b43746909ac3429cf44e2e4014431bbf";
    sha256 = "0kxr69fkn9l3zf2xrs20jl15sifmvwaz7qchlgzkjjzx5r122qsm";
  };


  # BBPSDK boost.python bindings take more than 1G mem per core to compile
  # with recent GCC, disable parallel buildings or GCC SIGBUS
  enableParallelBuilding = false;


  propagatedBuildInputs = [ brion lunchbox ];

}

