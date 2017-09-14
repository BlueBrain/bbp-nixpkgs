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
	version = "0.3.0-201709";

	buildInputs = [ cmake pkgconfig boost assimp ospray freeglut libXmu libXi
					glew vmmlib lunchbox brion hdf5-cpp imagemagick deflect ]
				  ++ (stdenv.lib.optional) (restInterface) [ zerobuf zeroeq lexis zerobuf.python ];

	src = fetchgit {
		url  = "https://github.com/BlueBrain/Brayns.git";
		rev = "355726ca528ab5d9fa01d7be324b9fc4c55bc260";
		sha256 = "17p6nha0byfrildy58rvwa26dqx8irgdi3l5h62a29i356nvk248";
	};


	cmakeFlags = [ 
			"-DCOMMON_DISABLE_WERROR=TRUE"
			"-DOSPRAY_ROOT=${ospray}"
			"-DEMBREE_ROOT=${embree}"
			"-DBRAYNS_USE_OPTIONAL_DEPENDENCY=ON"
			"-DBRAYNS_LIVRE_ENABLED=OFF"
		    ];


  enableParallelBuilding = true;
	

}
