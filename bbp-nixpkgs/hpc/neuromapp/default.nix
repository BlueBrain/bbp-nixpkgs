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
    rev = "c2d8f4609ba80f1f905996f716800c82af15e88a";
    sha256 = "0apfybi9zz3dnlxkqmvlj2l750n8i122jxjmgss418przjad85mg";
  };

  cmakeFlags= "-DBoost_NO_BOOST_CMAKE=TRUE -DBoost_USE_STATIC_LIBS=FALSE ";

  enableParallelBuilding = true;
}

