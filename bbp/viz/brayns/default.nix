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
	version = "0.3.0-201710";

	buildInputs = [ cmake pkgconfig boost assimp ospray freeglut libXmu libXi tbb
					glew vmmlib lunchbox brion hdf5-cpp imagemagick deflect ]
				  ++ (stdenv.lib.optional) (restInterface) [ zerobuf zeroeq lexis zerobuf.python ];

	src = fetchgit {
		url  = "https://github.com/BlueBrain/Brayns.git";
		rev = "e80493686378d825608f35d3ea1db4fd748dfaca";
		sha256 = "03p5vv8rxbrkgfx92vdfvd81m3lcivwxba9yar6d0mzq0lc5jxlp";
	};


	cmakeFlags = [ 
			"-DCOMMON_DISABLE_WERROR=TRUE"
			"-DOSPRAY_ROOT=${ospray}"
		    ];


  enableParallelBuilding = true;
	

}
