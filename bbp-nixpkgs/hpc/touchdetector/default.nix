{ stdenv, 
fetchgitPrivate, 
pkgconfig, 
boost, 
hpctools, 
libxml2, 
cmake, 
mpiRuntime, 
zlib, 
hdf5
}:

stdenv.mkDerivation rec {
  name = "touchdetector-4.3.0-DEV";
  buildInputs = [ stdenv pkgconfig boost hpctools zlib cmake mpiRuntime libxml2  hdf5 ];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/TouchDetector";
    rev = "ab0efad63c5c7be7f5c04e76ecaa02cdb44aabcf";
    sha256 = "0rpr5zlml4zbyvi0gvvhby48ayh19dcvam6j3zl9lga5xl74v6dr";
  };

  enableParallelBuilding = true;
}


