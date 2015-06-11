{ stdenv, fetchgitPrivate, pkgconfig, boost, hpctools, libxml2, cmake, bbp-cmake, mpich2, python, zlib, hdf5, doxygen }:

stdenv.mkDerivation rec {
  name = "touchdetector-4.0.0.0.TRUNK";
  buildInputs = [ stdenv pkgconfig boost hpctools zlib cmake mpich2 libxml2 python hdf5 doxygen];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/TouchDetector";
    rev = "e9b23369ead216d35deb92efb3e6ab485590b7e1";
    sha256 = "0qvaxy1sk9yq9hm2yl720rxb9ivc7qlnf869l7l1paklhn19b608";
  };

  patchPhase= ''
	ln -s ${bbp-cmake}/share/bbp-cmake/Common CMake/common &&
	sed -i 's@set(Boost_USE_STATIC_LIBS ON)@set(Boost_USE_STATIC_LIBS OFF)@g' CMakeLists.txt	
	'';   
	
  cmakeFlags="-DBoost_USE_STATIC_LIBS=FALSE";  	

  enableParallelBuilding = true;
}


