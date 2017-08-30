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
  version = "2.0-dev2017.08";

  buildInputs = [ stdenv pkgconfig 
				  mvdtool boost 
				  python pythonPackages.numpy pythonPackages.sphinx pythonPackages.lxml
				  cmake vmmlib servus lunchbox keyv hdf5-cpp zlib doxygen ];

  src = fetchgit {
    url = "https://github.com/BlueBrain/Brion.git";
    rev = "a91ee6815a54a56b7836b89b9d9374caa7a473b4";
    sha256 = "1k823cx2jgz0zf0a7lw5qha0rlqsnn3k68cqk7i69hw5v15isj1h";
  };


  enableParallelBuilding = true;


  propagatedBuildInputs = [ servus vmmlib boost ];
   
}


