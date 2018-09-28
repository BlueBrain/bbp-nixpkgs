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
, vrpn
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
	version = "0.7.0-201809";

	buildInputs = [ cmake pkgconfig boost assimp ospray freeglut libXmu libXi tbb libuv vrpn
					glew mesa vmmlib lunchbox brion hdf5-cpp freeimage deflect libarchive libjpeg_turbo]
				  ++ (stdenv.lib.optional) (restInterface) [ rockets ];

	src = fetchgit {
		url  = "https://github.com/BlueBrain/Brayns.git";
		rev = "ca1b622db4e07e67ba84609a77136439a200411b";
		sha256 = "07bhrpxfaz5hxdxhrfc9ij7v9fmiikq5pq78qv9xi4a2vkkl313p";
	};


	cmakeFlags = [ 
			"-DCOMMON_DISABLE_WERROR=TRUE"
			"-DOSPRAY_ROOT=${ospray}"
			"-DBRAYNS_STEREOSCOPY_ENABLE=TRUE"
			"-DBRAYNS_OPENDECK_ENABLED=TRUE"
			"-DBRAYNS_VRPN_ENABLED=TRUE"
		    ];

	# verbose mode for debugging
	makeFlags = [ "VERBOSE=1" ];

  enableParallelBuilding = true;
	

}
