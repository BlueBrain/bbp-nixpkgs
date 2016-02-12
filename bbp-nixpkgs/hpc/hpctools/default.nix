{ stdenv, fetchgitPrivate, boost, libxml2, cmake, mpiRuntime, pkgconfig, python, hdf5, doxygen }:

stdenv.mkDerivation rec {
  name = "hpctools-3.3.0-DEV";
  buildInputs = [ stdenv pkgconfig boost cmake mpiRuntime libxml2 python hdf5 doxygen];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/hpc/HPCTools";
    rev = "82b0f680365f4e7871275b4d84efe610b7521567";
    sha256 = "0pk52d4jrbdxclzyjhmqkx9zr296h5fa7daz6d1rcjgw9dxlg3kb";    
  };
      
  
  enableParallelBuilding = true;  
}

