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
mpich2, 
zlib, 
python, 
numpy,
hdf5, 
doxygen }:

stdenv.mkDerivation rec {
  name = "flatindexer-1.7.0-0.TRUNK";
  buildInputs = [ stdenv pkgconfig boost cmake bbp-cmake bbpsdk brion lunchbox vmmlib servus zlib python numpy hdf5 doxygen];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/FLATIndex";
    rev = "44fc6a986d4f73dbb2411ee319ab53c1bb8b321b";
    sha256 = "1yimz0dby2ycmfy93f8j2prb1i82pqrnp7figxs5gcp0qv7gghsc";
  };
  
  
  patchPhase= ''
	ln -s ${bbp-cmake}/share/bbp-cmake/Common CMake/common &&
	rm -rf \.gitexternals
	'';
	
  cmakeFlags="-DFLAT_PYTHON=OFF -DDISABLE_SUBPROJECTS=YES";

  enableParallelBuilding = true;
}


