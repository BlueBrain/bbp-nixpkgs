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
, cudatoolkit9
, optix
, nvidia-drivers
}:



assert restInterface -> (rockets != null);

stdenv.mkDerivation rec {
	name = "brayns-${version}";
	version = "latest";

	buildInputs = [ cmake pkgconfig boost assimp ospray freeglut libXmu libXi tbb libuv vrpn
					glew mesa vmmlib lunchbox brion hdf5-cpp freeimage deflect libarchive libjpeg_turbo bbptestdata cudatoolkit9 optix nvidia-drivers ]
				  ++ (stdenv.lib.optional) (restInterface) [ rockets ];

	src = fetchgit {
		url  = "https://github.com/BlueBrain/Brayns.git";
		rev = "ed790be88b6a66ddb6f75eebd07269cbb6007616";
		sha256 = "1fgp1zb73581hylmvf2zw1gy5w6jlmng6923wkxm2jq9crgm3bkq";
	};


	cmakeFlags = [
			"-DGIT_REVISION=27d45918"
			"-DOSPRAY_ROOT=${ospray}"
			"-DBRAYNS_STEREOSCOPY_ENABLED=TRUE"
			"-DBRAYNS_OPENDECK_ENABLED=TRUE"
			"-DBRAYNS_OPTIX_ENABLED=ON"
			"-DBRAYNS_VRPN_ENABLED=TRUE"
			"-DCOMMON_DISABLE_WERROR=TRUE"
		    ];

	doCheck = true;
	checkPhase = ''
		export LD_LIBRARY_PATH=''${PWD}/lib/:${nvidia-drivers}/lib:''${LD_LIBRARY_PATH}
		export CUDA_VISIBLE_DEVICES=0
		make Brayns-tests
	'';
	checkTarget="Brayns-tests";
        enableParallelBuilding = true;

}
