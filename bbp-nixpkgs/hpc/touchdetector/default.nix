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
    rev = "ddb6465d55ac838557bb311be66d0dcc77d61a9e";
    sha256 = "033ifnvj4b9n3kgi8153h5dhahyarhdbhx785khmd1h8vsaghzj1";
  };

  enableParallelBuilding = true;
}


