{ stdenv
, fetchgit
, cmake
, pkgconfig
, boost
, assimp ? null
, ospray
, embree 
, freeglut
, libXmu
, libXi
, glew
, vmmlib 
, lunchbox
, zerobuf ? null
, zeroeq ? null
, lexis ? null
, deflect ? null
, brion
, hdf5-cpp
, imagemagick
, restInterface ? true
}:



assert restInterface -> (zeroeq != null && zerobuf != null && lexis != null );

stdenv.mkDerivation rec {
	name = "brayns-${version}";
	version = "0.3.0-201708";

	buildInputs = [ cmake pkgconfig boost assimp ospray freeglut libXmu libXi
					glew vmmlib lunchbox brion hdf5-cpp imagemagick deflect ]
				  ++ (stdenv.lib.optional) (restInterface) [ zerobuf zeroeq lexis zerobuf.python ];

	src = fetchgit {
		url  = "https://github.com/BlueBrain/Brayns.git";
		rev = "6131e67b6a3213182226827aa728797205a64f57";
		sha256 = "0qma41377a7n0r0i7ps1bbdwni9p88s3f2j2pvy660yxmw9sa227";
	};


	cmakeFlags = [ 
			"-DCOMMON_DISABLE_WERROR=TRUE"
			"-DOSPRAY_ROOT=${ospray}"
			"-DEMBREE_ROOT=${embree}"
			"-DBRAYNS_USE_OPTIONAL_DEPENDENCY=ON"
			"-DBRAYNS_LIVRE_ENABLED=OFF"
			"-DBRAYNS_NETWORKING_ENABLED=ON"
		    ];


  enableParallelBuilding = true;
	

}
