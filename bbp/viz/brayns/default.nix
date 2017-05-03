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
	version = "0.2.0-201704";

	buildInputs = [ cmake pkgconfig boost assimp ospray freeglut libXmu libXi
					glew vmmlib lunchbox brion hdf5-cpp imagemagick deflect ]
				  ++ (stdenv.lib.optional) (restInterface) [ zerobuf zeroeq lexis zerobuf.python ];

	src = fetchgitExternal {
		url  = "https://github.com/BlueBrain/Brayns.git";
		rev = "b0904d19572859322b87db812884dacb34757cbd";
		sha256 = "06q80njmfzs51w766wm46l1kybwna6iw90nb1ggpwks57r1cr5v8";
	};


	cmakeFlags = [ 
				"-DCOMMON_DISABLE_WERROR=TRUE"
				"-DOSPRAY_ROOT=${ospray}"
		        "-DEMBREE_ROOT=${embree}"
		    ];


  enableParallelBuilding = true;
	

}
