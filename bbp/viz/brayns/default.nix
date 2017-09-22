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
		rev = "d0fad9147a6923a505c3b765ea13140c5bc65614";
		sha256 = "1691glv7mk7im4ymh4vzazypnb3wc3wzn3qix0jggqlpdfym78pb";
	};


	cmakeFlags = [ 
			"-DCOMMON_DISABLE_WERROR=TRUE"
			"-DBRAYNS_USE_OPTIONAL_DEPENDENCY=ON"
			"-DBRAYNS_LIVRE_ENABLED=OFF"
			"-DBRAYNS_NETWORKING_ENABLED=ON"
                        "-DDISABLE_SUBPROJECTS=TRUE"
		    ];


  enableParallelBuilding = true;
	

}
