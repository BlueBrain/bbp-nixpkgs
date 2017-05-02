{ stdenv, 
fetchgitExternal, 
boost, 
cmake, 
servus, 
lunchbox, 
keyv,
vmmlib,
pkgconfig, 
hdf5-cpp, 
zlib, 
mvdtool,
python,
pythonPackages,
doxygen }:

stdenv.mkDerivation rec {
  name = "brion-${version}";
  version = "2.0-2017.04";

  buildInputs = [ stdenv pkgconfig 
				  mvdtool boost 
				  python pythonPackages.numpy 
				  cmake vmmlib servus lunchbox keyv hdf5-cpp zlib doxygen ];

  src = fetchgitExternal {
    url = "https://github.com/BlueBrain/Brion.git";
    rev = "b075655b997858bd242b75f66702930315039358";
    sha256 = "0mnvwhf8rlv0nxlr6yrr4pm49k2j3x5zchnqfriab27j5fsxsh9i";
  };


  enableParallelBuilding = true;


  propagatedBuildInputs = [ lunchbox vmmlib boost ];
   
}


