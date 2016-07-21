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
    rev = "701f5c376ae41bc931286e29446ee8b67951844f";
    sha256 = "0n33djlsc2jlb4gb0faz1g9r8hrimgkmn1mr6zqjl5f2yjl0c705"; 
  };
  
 	
  cmakeFlags='' '';

  CXXFLAGS=" -Wno-error";

  enableParallelBuilding = true;
}


