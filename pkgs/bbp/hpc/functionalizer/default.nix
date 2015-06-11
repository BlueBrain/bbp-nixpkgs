{ stdenv, fetchgitPrivate, pkgconfig, boost, hpctools, libxml2, cmake, bbp-cmake, mpich2, zlib, python, hdf5, doxygen }:

stdenv.mkDerivation rec {
  name = "functionalizer-3.5.0.0.DEV";
  buildInputs = [ stdenv pkgconfig boost hpctools zlib cmake mpich2 libxml2 python hdf5 doxygen];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/Functionalizer";
    rev = "1b12785c2b402870f5e497d7b7ee148d1ae0fdcc";
    sha256 = "042p54xjm8fgrzac1dimcz6fcw3x27svdvrw86cjb1qfzmhdyk2q";
  };
  
  cmakeFlags="-DBoost_USE_STATIC_LIBS=FALSE";  
  
  patchPhase= ''
	ln -s ${bbp-cmake}/share/bbp-cmake/Common CMake/common &&
	sed -i 's@include(CommonCPack)@@g' CMakeLists.txt &&
	sed -i 's@include(CPackConfig)@@g' CMakeLists.txt &&
	sed -i 's@set(Boost_USE_STATIC_LIBS ON)@set(Boost_USE_STATIC_LIBS OFF)@g' CMakeLists.txt
	'';    

  enableParallelBuilding = true;
}


