{ stdenv, fetchgitPrivate, boost, libxml2, cmake, mpiRuntime, pkgconfig, python, hdf5, doxygen }:

stdenv.mkDerivation rec {
  name = "hpctools-${version}";
  version = "3.3.0";
  buildInputs = [ stdenv pkgconfig boost cmake mpiRuntime libxml2 python hdf5 doxygen];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/hpc/HPCTools";
    rev = "acbccdad7b3e87c15712cb891b77232a918b2d36";
    sha256 = "1phnl4lc78iv3igijqvak1ifwhivkw967dxblf536q8wawsk49ya";    
  };
      
  
  enableParallelBuilding = true;  
}

