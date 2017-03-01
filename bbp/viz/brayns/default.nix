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
		rev = "a163a81607089a2788c4a4560eca68b379a3d310";
		sha256 = "1lbnadqjyd700p045na7y2zq901jvrrkr9s6gymqsw4nbd0d9dzf";
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
