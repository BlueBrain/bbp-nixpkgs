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
, lexis ? null
, deflect ? null
, rockets ? null
, brion
, hdf5-cpp
, imagemagick
, restInterface ? true
}:



assert restInterface -> (rockets != null && zerobuf != null && lexis != null );

stdenv.mkDerivation rec {
	name = "brayns-${version}";
	version = "0.3.0-201710";

	buildInputs = [ cmake pkgconfig boost assimp ospray freeglut libXmu libXi tbb
					glew vmmlib lunchbox brion hdf5-cpp imagemagick deflect ]
				  ++ (stdenv.lib.optional) (restInterface) [ zerobuf rockets lexis zerobuf.python  ];

	src = fetchgit {
		url  = "https://github.com/BlueBrain/Brayns.git";
		rev = "2d1c204b5f6fb740a353017eba0dc291d5a47bd6";
		sha256 = "1wzkq258nf9m077b50i8msl9n06rk760vdk6gdhqf1ih0gdj6mzd";
	};


	cmakeFlags = [ 
			"-DCOMMON_DISABLE_WERROR=TRUE"
			"-DOSPRAY_ROOT=${ospray}"
		    ];


  enableParallelBuilding = true;
	

}
