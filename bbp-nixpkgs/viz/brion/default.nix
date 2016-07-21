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
  name = "brion-${version}";
  version = "1.8";

  buildInputs = [ stdenv pkgconfig boost cmake vmmlib servus lunchbox hdf5-cpp zlib doxygen ];

  src = fetchgitExternal {
    url = "https://github.com/BlueBrain/Brion.git";
    rev = "2fccd3fb1de1056038d4e3cc6dd848c98754cec1";
    sha256 = "1fmqmj6zvw9c4m9b0fpmwq45dsnqghmiaqzk00q3dmrsf0hfpr6b";
  };


  enableParallelBuilding = true;

  ## horrible hack to disable the -WError maddness
  ##
  cmakeFlags = "-DXCODE_VERSION=1";
   
}


