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
		rev = "e86c74149870c04c085526073a5e3fa54ba92377";
		sha256 = "0mq8cdaj6b1dj1ls0plkz8675a58mhcxvcfagx8wh2g2w49hymp7";
	};


	cmakeFlags = [
			"-DGIT_REVISION=e86c7414"
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
