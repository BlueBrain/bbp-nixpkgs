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
highfive,
zlib, 
mvdtool,
python,
pythonPackages,
doxygen,
legacyVersion ? false
}:


let 
	legacy-info = {
		version = "2.0-legacy";
		rev = "bea8f838bc6d4c9b40bf90d1cdacaa625bbabe7b";
		sha256 = "03qlvxrl5vvmzg4d0v13nnihr09hp26fab69m8i09g6xhrq87cic";
	};

	last-info = {
		version = "2.0-dev2017.08";
		rev = "a91ee6815a54a56b7836b89b9d9374caa7a473b4";
		sha256 = "1k823cx2jgz0zf0a7lw5qha0rlqsnn3k68cqk7i69hw5v15isj1h";
	};

	brion-info = if (legacyVersion) then legacy-info else last-info;

in
stdenv.mkDerivation rec {
  name = "brion-${version}";
  version = brion-info.version;

  buildInputs = [ stdenv pkgconfig 
				  mvdtool boost 
				  python pythonPackages.numpy pythonPackages.sphinx pythonPackages.lxml
				  cmake vmmlib servus lunchbox keyv hdf5-cpp highfive zlib doxygen ];

  src = fetchgit {
    url = "https://github.com/BlueBrain/Brion.git";
    rev = brion-info.rev;
    sha256 = brion-info.sha256;
  };

  patches = (stdenv.lib.optionals) (legacyVersion) [ ./brion-legacy-higfive.patch ];

  enableParallelBuilding = false; # memory consumption too high for python bindings generation

  makeFlags = [ "VERBOSE=1" ];

  propagatedBuildInputs = [ servus vmmlib boost ];
   
}


