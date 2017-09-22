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
doxygen,
legacyVersion ? false,
generateDoc ? false
}:


let 
	legacy-info = {
		version = "2.0-legacy";
		rev = "bea8f838bc6d4c9b40bf90d1cdacaa625bbabe7b";
		sha256 = "1qhs9dzq8j8bdssqhmnxm5hm7bl2h8zipavzqx2va1jwg5f2mnr6";
	};

	last-info = {
		version = "2.0-dev2017.08";
		rev = "a91ee6815a54a56b7836b89b9d9374caa7a473b4";
		sha256 = "0nqy94kfk5qsplpsgbs5zf3l2imd85ga2173npmshmhyw2samw2h";
	};

	brion-info = if (legacyVersion) then legacy-info else last-info;

in
stdenv.mkDerivation rec {
  name = "brion-${version}";
  version = brion-info.version;

  buildInputs = [ stdenv pkgconfig 
				  mvdtool boost 
				  python pythonPackages.numpy pythonPackages.lxml
				  cmake vmmlib servus lunchbox keyv hdf5-cpp zlib ]
	++ (stdenv.lib.optionals) (generateDoc) [ pythonPackages.sphinx doxygen ];

  src = fetchgit {
    url = "https://github.com/BlueBrain/Brion.git";
    rev = brion-info.rev;
    sha256 = brion-info.sha256;
  };

  enableParallelBuilding = true;

  cmakeFlags = [ "-DDISABLE_SUBPROJECTS=TRUE" ];

  propagatedBuildInputs = [ servus vmmlib boost ];
   
}


