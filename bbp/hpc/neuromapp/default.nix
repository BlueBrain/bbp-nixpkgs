{ stdenv
, fetchFromGitHub
, pkgconfig
, boost
, cmake
, hdf5
, zlib
, mpiRuntime
, ncurses
, readline
, doxygen }:

stdenv.mkDerivation rec {
  name = "neuromapp-1.0.0";
  buildInputs = [ stdenv pkgconfig boost cmake hdf5 zlib mpiRuntime doxygen readline ncurses ];

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "neuromapp";
    rev = "51b3008bb2927c8a408fe1b7242ad1634b4aa1d0";
    sha256 = "0mlfbgz319pgqqsapk543ma3j5jn5251bs4inz5xfvna5xcilgzh";
  };

  cmakeFlags= [ "-DBoost_NO_BOOST_CMAKE=TRUE" "-DBoost_USE_STATIC_LIBS=FALSE"];

  enableParallelBuilding = true;
}

