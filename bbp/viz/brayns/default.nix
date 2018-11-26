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
, cudatoolkit92
, optix
, nvidia-drivers
}:



assert restInterface -> (rockets != null);

stdenv.mkDerivation rec {
	name = "brayns-${version}";
	version = "latest";

	buildInputs = [ cmake pkgconfig boost assimp ospray freeglut libXmu libXi tbb libuv vrpn
					glew mesa vmmlib lunchbox brion hdf5-cpp freeimage deflect libarchive libjpeg_turbo bbptestdata cudatoolkit92 optix nvidia-drivers ]
				  ++ (stdenv.lib.optional) (restInterface) [ rockets ];

	src = fetchgit {
		url  = "https://github.com/BlueBrain/Brayns.git";
		rev = "aa2622f97f9f2cf0c89c1c38bfaa109a14851f0e";
		sha256 = "0svpmb80sc86910rqyi8nv8jmk0x660bzgmm07k8dv2x4h4h9av0";
	};


	cmakeFlags = [
			"-DBRAYNS_OPTIX_TESTS_ENABLED=OFF"
			"-DGIT_REVISION=aa2622f9"
			"-DOSPRAY_ROOT=${ospray}"
			"-DBRAYNS_STEREOSCOPY_ENABLED=TRUE"
			"-DBRAYNS_OPENDECK_ENABLED=TRUE"
			"-DBRAYNS_OPTIX_ENABLED=ON"
			"-DBRAYNS_ASSIMP_ENABLED=ON"
			"-DBRAYNS_VRPN_ENABLED=TRUE"
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
