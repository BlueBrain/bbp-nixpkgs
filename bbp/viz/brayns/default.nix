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
		rev = "85e1d7915ed19614dc8da5ce91a9833d841c0305";
		sha256 = "1ickj6wsy842gck83ck44dy3zidlywf1155zc60wzl8j57xhrkz0";
	};


	cmakeFlags = [
			"-DGIT_REVISION=85e1d791"
			"-DOSPRAY_ROOT=${ospray}"
			"-DBRAYNS_STEREOSCOPY_ENABLED=TRUE"
			"-DBRAYNS_OPENDECK_ENABLED=TRUE"
			"-DBRAYNS_OPTIX_ENABLED=ON"
			"-DBRAYNS_VRPN_ENABLED=TRUE"
		    ];

	doCheck = true;
	checkPhase = ''
		echo '### hostname ' $(hostname)
	
		export LD_LIBRARY_PATH=''${PWD}/lib/:${nvidia-drivers}/lib:${cudatoolkit92}/lib/:${optix}/lib:''${LD_LIBRARY_PATH}
		export PATH=''${cudatoolkit92}/bin/:''${PATH}
		export LSAN_OPTIONS="suppressions=../../.lsan_suppressions.txt"
		export CUDA_VISIBLE_DEVICES=0
		nvcc --version
    		CUDA_VISIBLE_DEVICES=0 /nix/store/lhsynfsy979a6k933hqw3x12qmr02zqj-generated-env-module-cuda9/extras/demo_suite/deviceQuery
                ls ${nvidia-drivers}/lib
		echo $LD_LIBRARY_PATH
		make -j Brayns-tests
	'';
	enableParallelBuilding = true;
	 checkTarget="Brayns-tests";


}
