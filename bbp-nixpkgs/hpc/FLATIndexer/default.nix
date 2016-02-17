{ stdenv, 
fetchgitPrivate, 
pkgconfig, 
boost, 
bbpsdk, 
brion,
lunchbox, 
vmmlib,
servus,
cmake, 
cmake-external, 
mpiRuntime, 
zlib, 
python, 
hdf5, 
doxygen }:

stdenv.mkDerivation rec {
  name = "flatindexer-1.8.0";
  buildInputs = [ stdenv pkgconfig boost cmake cmake-external bbpsdk brion lunchbox vmmlib servus zlib python hdf5 doxygen];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/FLATIndex";
    rev = "3cdc827d13494648c186df167ba12d74ef1541ca";
    sha256 = "0apjmjhc1k05jyrm8z7n8d8m47wy8y0r9pbk7g1jyw09hghlcfrg";
    leaveDotGit = true; 
  };
  
 	
  cmakeFlags="-DFLAT_PYTHON=OFF";

  enableParallelBuilding = true;
}


