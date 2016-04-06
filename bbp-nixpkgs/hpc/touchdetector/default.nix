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
    rev = "8e81baec1380e8ee2041c046c80d40549c5514cd";
    sha256 = "04hkbp5vng6s5g1lkp3dxzl628ycf4a4m8x3w33yjbkb1j105i64";
  };

  enableParallelBuilding = true;
}


