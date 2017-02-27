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
  name = "flatindexer-${version}";
  version = "1.8.1";
  buildInputs = [ stdenv pkgconfig boost cmake  bbpsdk brion lunchbox vmmlib servus zlib python numpy hdf5 doxygen];

  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/building/FLATIndex";
    rev = "8bec30a23488bae6f9b8a0b40d53123e789a1904";
    sha256 = "133if0a5xk7vq7ddlyfq87d1ybg2kr6468mrw4nyb5cbnkrjdq5x"; 
  };
  
 	
  cmakeFlags='' '';

  CXXFLAGS=" -Wno-error";

  enableParallelBuilding = true;
}


