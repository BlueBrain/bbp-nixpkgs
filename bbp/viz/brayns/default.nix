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
, libuv
, glew
, mesa
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
	version = "0.6.0-201806";

	buildInputs = [ cmake pkgconfig boost assimp ospray freeglut libXmu libXi tbb libuv
					glew mesa vmmlib lunchbox brion hdf5-cpp imagemagick deflect ]
				  ++ (stdenv.lib.optional) (restInterface) [ rockets ];

	src = fetchgit {
		url  = "https://github.com/BlueBrain/Brayns.git";
		rev = "81740410ef40376753362b50a2eda93ec911fe30";
                sha256 = "13506jxb60kf35a1kpfg4c38md9l0x1izswbark1vy0wdwh1xmrr";
	};


	cmakeFlags = [ 
			"-DCOMMON_DISABLE_WERROR=TRUE"
			"-DOSPRAY_ROOT=${ospray}"
			"-DBRAYNS_OPENDECK_ENABLED=TRUE"
		    ];

	# verbose mode for debugging
	makeFlags = [ "VERBOSE=1" ];

  enableParallelBuilding = true;
	

}
