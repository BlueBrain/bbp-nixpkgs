{ stdenv
, fetchgit
, cmake
, pkgconfig
, boost
, assimp ? null
, ospray
, tbb
, freeglut
, freeimage
, libjpeg_turbo
, libXmu
, libXi
, libuv
, glew
, mesa
, vmmlib
, lunchbox
, deflect ? null
, rockets ? null
, brion
, hdf5-cpp
, restInterface ? true
, libarchive
}:



assert restInterface -> (rockets != null);

stdenv.mkDerivation rec {
	name = "brayns-${version}";
	version = "latest";

	buildInputs = [ cmake pkgconfig boost assimp ospray freeglut libXmu libXi tbb libuv
					glew mesa vmmlib lunchbox brion hdf5-cpp freeimage deflect libarchive libjpeg_turbo]
				  ++ (stdenv.lib.optional) (restInterface) [ rockets ];

	src = fetchgit {
		url  = "https://github.com/BlueBrain/Brayns.git";
		rev = "3e1d2610d44dc22644ef7e0682ee9fcc56c8720f";
		sha256 = "12wi5wd6dr6lfa9i03nyx2ibq7n2sp32kjr0m03sb9hzazinvga8";
	};


	cmakeFlags = [
			"-DCOMMON_DISABLE_WERROR=TRUE"
			"-DOSPRAY_ROOT=${ospray}"
			"-DBRAYNS_OPENDECK_ENABLED=TRUE"
		    ];

	# verbose mode for debugging
	makeFlags = [ "VERBOSE=1" ];

  enableParallelBuilding = true;
	

}
