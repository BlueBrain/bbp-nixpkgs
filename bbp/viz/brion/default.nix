{ stdenv, 
fetchgit,
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
  version = "2.0-2017.06";

  buildInputs = [ stdenv pkgconfig 
				  mvdtool boost 
				  python pythonPackages.numpy pythonPackages.sphinx pythonPackages.lxml
				  cmake vmmlib servus lunchbox keyv hdf5-cpp zlib doxygen ];

  src = fetchgit {
    url = "https://github.com/BlueBrain/Brion.git";
    rev = "460ea81f08d92f7c7d56ae79b830a275ccdeaeda";
    sha256 = "0x9j417xvdk0b56pgn0z8c7c0im8lysr4j6z8kgv63hixx5l23ll";
  };


  enableParallelBuilding = true;


  propagatedBuildInputs = [ servus vmmlib boost ];
   
}


