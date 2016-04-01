{ stdenv, 
fetchgitExternal, 
pkgconfig, 
boost, 
bbpsdk, 
brion,
lunchbox, 
vmmlib,
servus,
cmake, 
mpiRuntime, 
zlib, 
python, 
numpy,
hdf5, 
doxygen }:

stdenv.mkDerivation rec {
  name = "flatindexer-1.8.0";
  buildInputs = [ stdenv pkgconfig boost cmake  bbpsdk brion lunchbox vmmlib servus zlib python numpy hdf5 doxygen];

  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/building/FLATIndex";
    rev = "3360423a794b51170240a521caf010423fb5baca";
    sha256 = "1ljassdipl19w2x4c4gjskig2v5ylgr2f7rddqqyb990404423jz"; 
  };
  
 	
  cmakeFlags='' '';

  CXXFLAGS=" -Wno-error";

  enableParallelBuilding = true;
}


