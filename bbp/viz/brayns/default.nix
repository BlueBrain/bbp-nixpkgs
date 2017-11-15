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
	version = "0.3.0-201711";

	buildInputs = [ cmake pkgconfig boost assimp ospray freeglut libXmu libXi tbb
					glew vmmlib lunchbox brion hdf5-cpp imagemagick deflect ]
				  ++ (stdenv.lib.optional) (restInterface) [ zerobuf rockets lexis zerobuf.python  ];

	src = fetchgit {
		url  = "https://github.com/BlueBrain/Brayns.git";
		rev = "b10dfc204bc0577c8fae1931a5fa493a55f64c6a";
		sha256 = "0whgapq91pia1kn050s59zsfqd96syinhh66nf5dzdnvyd3vwmf9";
	};


	cmakeFlags = [ 
			"-DCOMMON_DISABLE_WERROR=TRUE"
			"-DOSPRAY_ROOT=${ospray}"
		    ];


  enableParallelBuilding = true;
	

}
