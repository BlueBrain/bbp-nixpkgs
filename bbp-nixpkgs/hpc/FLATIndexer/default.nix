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
    rev = "ab1727a301799d4c4c1b142c13ef56c965f94838";
    sha256 = "03x2k583nlk0xcfpdh76q3fcdfv32dvpfypgaqaq3k0l8mn41f4k"; 
  };
  
 	
  cmakeFlags='' '';

  CXXFLAGS=" -Wno-error";

  enableParallelBuilding = true;
}


