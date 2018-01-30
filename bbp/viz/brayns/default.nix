{ stdenv
, fetchgit
, cmake
, pkgconfig
, boost
, assimp ? null
, ospray
, tbb
, freeglut
, libXmu
, libXi
, glew
, vmmlib 
, lunchbox
, deflect ? null
, rockets ? null
, brion
, hdf5-cpp
, imagemagick
, restInterface ? true
}:



assert restInterface -> (rockets != null);

stdenv.mkDerivation rec {
	name = "brayns-${version}";
	version = "0.4.0-201801";

	buildInputs = [ cmake pkgconfig boost assimp ospray freeglut libXmu libXi tbb
					glew vmmlib lunchbox brion hdf5-cpp imagemagick deflect ]
				  ++ (stdenv.lib.optional) (restInterface) [ rockets ];

	src = fetchgit {
		url  = "https://github.com/BlueBrain/Brayns.git";
		rev = "ffc39492df08445b0969c03d1c8008b6720bbc2e";
		sha256 = "18j7nnycs2ad8bz9l1svs26060mjij5xpn8yrg1gcrqdzgd1n1c5";
	};


	cmakeFlags = [ 
			"-DCOMMON_DISABLE_WERROR=TRUE"
			"-DOSPRAY_ROOT=${ospray}"
		    ];


  enableParallelBuilding = true;
	

}
