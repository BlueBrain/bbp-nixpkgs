{ stdenv, fetchgitPrivate, boost, libxml2, cmake, bbp-cmake, mpich2, pkgconfig, python, hdf5, doxygen }:

stdenv.mkDerivation rec {
  name = "hpctools-3.2.0-DEV";
  buildInputs = [ stdenv pkgconfig boost cmake mpich2 libxml2 python hdf5 doxygen];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/hpc/HPCTools";
    rev = "2778b16bef77a0f83b71aa8f89df79bfc726203a";
    sha256 = "0b9kzr0wbh71lvnb45l7yzxv66s9s46b2733qndma32sf7wm2cxq";    
  };
  
  patchPhase= ''
	ln -s ${bbp-cmake}/share/bbp-cmake/Common CMake/common
	'';     
  
  enableParallelBuilding = true;  
}

