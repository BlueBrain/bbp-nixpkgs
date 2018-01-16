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
pythonPackages,
doxygen,
legacyVersion ? false
}:


let 
	legacy-info = {
		version = "2.0-legacy";
		rev = "bea8f838bc6d4c9b40bf90d1cdacaa625bbabe7b";
		sha256 = "1qhs9dzq8j8bdssqhmnxm5hm7bl2h8zipavzqx2va1jwg5f2mnr6";
	};

	last-info = {
		version = "3.0-dev2017.10";
		rev = "5396f1e73b0b4df1691d1126a0dbdcfdb7100c7a";
		sha256 = "1b2gjzyad2jwa9md8vhvi3m9x2xpywdx21m1pb4ld5hsxjw7nhnf";
	};

	brion-info = if (legacyVersion) then legacy-info else last-info;

in
stdenv.mkDerivation rec {
  name = "brion-${version}";
  version = brion-info.version;

  buildInputs = [ stdenv pkgconfig 
				  mvdtool boost 
				  pythonPackages.python pythonPackages.numpy pythonPackages.lxml
				  cmake vmmlib servus lunchbox keyv hdf5-cpp highfive zlib doxygen ];

  src = fetchgit {
    url = "https://github.com/BlueBrain/Brion.git";
    rev = brion-info.rev;
    sha256 = brion-info.sha256;
  };

  patches = (stdenv.lib.optionals) (legacyVersion) [ ./brion-legacy-higfive.patch ];

  enableParallelBuilding = false; # memory consumption too high for python bindings generation

  cmakeFlags = [ "-DDISABLE_SUBPROJECTS=TRUE" ];

  makeFlags = [ "VERBOSE=1" ];

  propagatedBuildInputs = [ servus vmmlib boost ];

  passthru = {
    pythonModule = pythonPackages.python;
  };

   
}


