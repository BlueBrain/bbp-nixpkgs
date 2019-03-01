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
, highfive
, restInterface ? true
, libarchive
, cudatoolkit92
, optix
, nvidia-drivers
, xorg
, libxkbcommon
}:



assert restInterface -> (rockets != null);

stdenv.mkDerivation rec {
	name = "brayns-${version}";
	version = "latest";

	buildInputs = [ cmake pkgconfig boost assimp ospray freeglut libXmu libXi tbb libuv vrpn highfive
					glew mesa vmmlib lunchbox brion hdf5-cpp freeimage deflect libarchive libjpeg_turbo bbptestdata cudatoolkit92 optix nvidia-drivers xorg.libXrandr.dev xorg.libXrandr xorg.libXinerama.dev xorg.libXcursor.dev libxkbcommon.dev ]
				  ++ (stdenv.lib.optional) (restInterface) [ rockets ];

	src = fetchgit {
		url  = "https://github.com/BlueBrain/Brayns.git";
		rev = "55a0381a1098d8a3446ff05f6876abe7047d8093";
		sha256 = "0ids99s9mf9winbjigp72iyahd41zacyffrdx28qgzwarm0n2rkb";
	};


	cmakeFlags = [
			"-DBRAYNS_OPTIX_TESTS_ENABLED=OFF"
			"-DGIT_REVISION=55a0381a"
			"-DOSPRAY_ROOT=${ospray}"
			"-DBRAYNS_STEREOSCOPY_ENABLED=TRUE"
			"-DBRAYNS_OPENDECK_ENABLED=TRUE"
			"-DBRAYNS_OPTIX_ENABLED=ON"
			"-DBRAYNS_ASSIMP_ENABLED=ON"
			"-DBRAYNS_CIRCUITVIEWER_ENABLED=ON"
			"-DBRAYNS_VRPN_ENABLED=TRUE"
			"-DBRAYNS_NETWORKING_ENABLED=ON"
			"-DBRAYNS_DEFLECT_ENABLED=ON"
		    ];

	doCheck = true;
	checkPhase = ''
		export LD_LIBRARY_PATH=''${PWD}/lib/:${nvidia-drivers}/lib:${cudatoolkit92}/lib/:${optix}/lib:''${LD_LIBRARY_PATH}
		export LSAN_OPTIONS="suppressions=../../.lsan_suppressions.txt"
		make -j Brayns-tests
	'';
	enableParallelBuilding = true;
	 checkTarget="Brayns-tests";


}
