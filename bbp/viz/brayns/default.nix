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
		rev = "3c381bfae0361508e87a8d0b066d7c3f3724bd66";
		sha256 = "1j2hmrvmwmjn0h5ig84455av38pvgx3ch16h5jqb8wmh1lkr9a45";
	};


	cmakeFlags = [
			"-DGIT_REVISION=3c381bfa"
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
