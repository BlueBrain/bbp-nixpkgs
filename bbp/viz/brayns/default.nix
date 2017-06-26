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
	version = "0.3.0-201706";

	buildInputs = [ cmake pkgconfig boost assimp ospray freeglut libXmu libXi
					glew vmmlib lunchbox brion hdf5-cpp imagemagick deflect ]
				  ++ (stdenv.lib.optional) (restInterface) [ zerobuf zeroeq lexis zerobuf.python ];

	src = fetchgit {
		url  = "https://github.com/BlueBrain/Brayns.git";
		rev = "19e95d3643ab19d29199639102900bb5b69fbdb7";
		sha256 = "1pnz859s684aahn82bpdafpnaizapamchiagswzn2kxfhdi9s7sr";
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
