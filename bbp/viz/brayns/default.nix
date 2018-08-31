{ stdenv
, bbptestdata
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
					glew mesa vmmlib lunchbox brion hdf5-cpp freeimage deflect libarchive libjpeg_turbo bbptestdata]
				  ++ (stdenv.lib.optional) (restInterface) [ rockets ];

	src = fetchgit {
		url  = "https://github.com/BlueBrain/Brayns.git";
		rev = "e6aa3fcbb71ee5e5631d85d8deeb4d5bd5c18f18";
		sha256 = "12fk1awrnszgrf04rszfl4hpqrjw7baprgmgj9lazny7qla8y6l8";
	};


	cmakeFlags = [
			"-DCOMMON_DISABLE_WERROR=TRUE"
			"-DOSPRAY_ROOT=${ospray}"
			"-DBRAYNS_OPENDECK_ENABLED=TRUE"
			"-DCMAKE_C_FLAGS=-fsanitize=leak"
			"-DCMAKE_CXX_FLAGS=-fsanitize=leak"
		    ];

	doCheck = true;
	checkPhase = ''
	export LD_LIBRARY_PATH=''${PWD}/lib/:''${LD_LIBRARY_PATH}
	make Brayns-tests
	'';

	checkTarget="Brayns-tests";
  enableParallelBuilding = true;
	

}
