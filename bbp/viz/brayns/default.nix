{ stdenv
, fetchgitExternal
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
	version = "0.1.0";

	buildInputs = [ cmake pkgconfig boost assimp ospray freeglut libXmu libXi
					glew vmmlib lunchbox brion hdf5-cpp imagemagick deflect ]
				  ++ (stdenv.lib.optional) (restInterface) [ zerobuf zeroeq lexis zerobuf.python ];

	src = fetchgitExternal {
		url  = "https://github.com/BlueBrain/Brayns.git";
		rev = "80b143251c4b8b366e2e959b8b73e124d6e1d314";
		sha256 = "18v4lk3rinvdh63xjpcm32kc22nljp8y9mzbd1cgmbpx1742j9bh";
	};


	cmakeFlags = [ 
				"-DOSPRAY_ROOT=${ospray}"
				"-DBRAYNS_REST_ENABLED=${if restInterface then "TRUE" else "FALSE"}" 
                "-DEMBREE_ROOT=${embree}"
				## horrible hack to solve
				## this idiotic -WError at release time....
				"-DXCODE_VERSION=1" ];

  enableParallelBuilding = true;
	

}
