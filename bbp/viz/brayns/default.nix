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
		rev = "22ed0a8dd38df629a373c15a917e21e1ea4d87ba";
		sha256 = "0mlnccbxydwrmici4lc8j49qrjrqgd32v68q4jcn57hd8wa1bghr";
	};

    patches = [ ./decouple_common.patch ];

	cmakeFlags = [ 
				"-DCOMMON_DISABLE_WERROR=TRUE"
				"-DOSPRAY_ROOT=${ospray}"
		        "-DEMBREE_ROOT=${embree}"
		    ];


  enableParallelBuilding = true;
	

}
