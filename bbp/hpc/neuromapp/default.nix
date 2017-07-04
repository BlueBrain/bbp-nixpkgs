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
  name = "neuromapp-${version}";
  version = "2017.06";

  buildInputs = [ stdenv pkgconfig boost cmake hdf5 zlib mpiRuntime doxygen readline ncurses ];

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "neuromapp";
    rev = "7c5bea38a577d21250ab5986186f100d74e7a4f9";
    sha256 = "0s1q8by7zq917gwxkdw7s6c5qj9jpizqxfsnvi1nxy0y1diz89xv";
  };

  cmakeFlags= [ "-DBoost_NO_BOOST_CMAKE=TRUE" "-DBoost_USE_STATIC_LIBS=FALSE"];

  enableParallelBuilding = true;
}

