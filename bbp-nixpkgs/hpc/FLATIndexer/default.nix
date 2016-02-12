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
bbp-cmake, 
mpiRuntime, 
zlib, 
python, 
numpy,
hdf5, 
doxygen }:

stdenv.mkDerivation rec {
  name = "flatindexer-1.8.0-stable";
  buildInputs = [ stdenv pkgconfig boost cmake bbp-cmake bbpsdk brion lunchbox vmmlib servus zlib python numpy hdf5 doxygen];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/FLATIndex";
    rev = "3cdc827d13494648c186df167ba12d74ef1541ca";
    sha256 = "0m4l13gsd34rfcl0k12baf3wywgcwb6r82k26k8n4jzyb3qfs7qh";
  };
  
  
  patchPhase= ''
	ln -s ${bbp-cmake}/share/bbp-cmake/Common CMake/common &&
	rm -rf \.gitexternals
	'';
	
  cmakeFlags="-DFLAT_PYTHON=OFF -DDISABLE_SUBPROJECTS=YES";

  enableParallelBuilding = true;
}


