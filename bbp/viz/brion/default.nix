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
		version = "3.0-dev2017.10";
		rev = "5396f1e73b0b4df1691d1126a0dbdcfdb7100c7a";
		sha256 = "19saq2mcwf4aiy0i461xs3n9pfjr650z3ws8amqdahs8kq0a0y0s";
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


