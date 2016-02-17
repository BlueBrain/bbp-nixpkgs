{ stdenv, 
fetchgit, 
boost, 
cmake, 
cmake-external, 
servus, 
lunchbox, 
vmmlib, 
cppcheck, 
pkgconfig, 
hdf5-cpp, 
zlib, 
mvdtool,
doxygen }:

stdenv.mkDerivation rec {
  name = "brion-1.6.0-DEV";
  buildInputs = [ stdenv pkgconfig boost cmake cmake-external servus lunchbox vmmlib hdf5-cpp zlib doxygen cppcheck];

  src = fetchgit {
    url = "https://github.com/BlueBrain/Brion.git";
    rev = "8e3b87ef49b7ec18fb8173f3d0335b6475ca1d0c";
    sha256 = "1b64xvi47vyjk8dfyqdikwsnibq1fhh0g774vxb3j24gvkccvy4j";
    leaveDotGit = true;
  };


  enableParallelBuilding = true;
    
}


