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
, mesa
, vmmlib 
, lunchbox
, deflect ? null
, rockets ? null
, brion
, hdf5-cpp
, imagemagick
, restInterface ? true
}:



assert restInterface -> (rockets != null);

stdenv.mkDerivation rec {
	name = "brayns-${version}";
	version = "0.5.0-201802";

	buildInputs = [ cmake pkgconfig boost assimp ospray freeglut libXmu libXi tbb
					glew mesa vmmlib lunchbox brion hdf5-cpp imagemagick deflect ]
				  ++ (stdenv.lib.optional) (restInterface) [ rockets ];

	src = fetchgit {
		url  = "https://github.com/BlueBrain/Brayns.git";
		rev = "b9af13183b934b654d04b4879ab30ad299e331e1";
		sha256 = "0q2ayp2q4cgf0n8dgkmvfh11g54qkkya21g1dnj36ky7f45iyx1g";
	};


	cmakeFlags = [ 
			"-DCOMMON_DISABLE_WERROR=TRUE"
			"-DOSPRAY_ROOT=${ospray}"
		    ];

	# verbose mode for debugging
	makeFlags = [ "VERBOSE=1" ];

  enableParallelBuilding = true;
	

}
