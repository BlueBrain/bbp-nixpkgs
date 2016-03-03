{ stdenv, 
fetchgitExternal, 
boost, 
cmake, 
servus, 
lunchbox, 
vmmlib,
pkgconfig, 
hdf5-cpp, 
zlib, 
mvdtool,
doxygen }:

stdenv.mkDerivation rec {
  name = "brion-1.6.0-DEV";
  buildInputs = [ stdenv pkgconfig boost cmake vmmlib servus lunchbox hdf5-cpp zlib doxygen ];

  src = fetchgitExternal {
    url = "https://github.com/BlueBrain/Brion.git";
    rev = "f936a450d6bdd56355f2752d9038fcc39ebb7943";
    sha256 = "1cn6fcg9whjnq2344sw6mdj1xf7dsb7sp3m5csdxk421n5i2xlpm";
  };


  enableParallelBuilding = true;


   
}


