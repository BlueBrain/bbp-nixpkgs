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
    rev = "32ac7ab928d9079797f58ca3cfd794e44de556fb";
    sha256 = "1jwrw19cb2b76l4x2s17m1y8g2pf8zr3vvdg91z9qcjvmazc8za0";
  };

  enableParallelBuilding = true;
}


