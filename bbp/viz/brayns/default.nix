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
	version = "latest";

	buildInputs = [ cmake pkgconfig boost assimp ospray freeglut libXmu libXi tbb libuv vrpn
					glew mesa vmmlib lunchbox brion hdf5-cpp freeimage deflect libarchive libjpeg_turbo bbptestdata]
				  ++ (stdenv.lib.optional) (restInterface) [ rockets ];

	src = fetchgit {
		url  = "https://github.com/BlueBrain/Brayns.git";
		rev = "5e34a1f13272e605c24a1a65db3a62fb4600ac67";
		sha256 = "09116smhdspcbyjbyhx32z5gc79c7kspk27csb9zhjrl8892d4ws";
	};


	cmakeFlags = [
			"-DGIT_REVISION=5e34a1f1"
			"-DOSPRAY_ROOT=${ospray}"
			"-DBRAYNS_STEREOSCOPY_ENABLED=TRUE"
			"-DBRAYNS_OPENDECK_ENABLED=TRUE"
			"-DCMAKE_C_FLAGS=-fsanitize=leak"
			"-DCMAKE_CXX_FLAGS=-fsanitize=leak"
			"-DBRAYNS_VRPN_ENABLED=TRUE"
		    ];

	doCheck = true;
	checkPhase = ''
	export LD_LIBRARY_PATH=''${PWD}/lib/:''${LD_LIBRARY_PATH}
	make Brayns-tests
	'';

	checkTarget="Brayns-tests";
  enableParallelBuilding = true;
	

}
