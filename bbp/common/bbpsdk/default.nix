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
  version = "0.26-dev201708";
  buildInputs = [ stdenv pkgconfig boost brion vmmlib servus mvdtool cmake lunchbox python hdf5 doxygen];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/common/BBPSDK";
    rev = "d3ba7b165c3fafdf8fd438be9248d80c8fc3ab8b";
    sha256 = "1vf6i6pdjqbdww0lq4z6g6vvrs46czf444jv85shyd8achhmg055";
  };


  # BBPSDK boost.python bindings take more than 1G mem per core to compile
  # with recent GCC, disable parallel buildings or GCC SIGBUS
  enableParallelBuilding = false;


  propagatedBuildInputs = [ brion lunchbox ];

}

