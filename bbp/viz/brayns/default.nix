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
		rev = "a525e6f86672f58108dd5fc90dcae30353945811";
		sha256 = "13vz0bdgrj82npnd51k8wy6hinl731jdizlrx9b8i3h7968945mj";
		rev = "ca1b622db4e07e67ba84609a77136439a200411b";
		sha256 = "07bhrpxfaz5hxdxhrfc9ij7v9fmiikq5pq78qv9xi4a2vkkl313p";
	};


	cmakeFlags = [
			"-DGIT_REVISION=a525e6f8"
			"-DOSPRAY_ROOT=${ospray}"
			"-DBRAYNS_STEREOSCOPY_ENABLED=TRUE"
			"-DBRAYNS_OPENDECK_ENABLED=TRUE"
			"-DBRAYNS_OPTIX_ENABLED=ON"
			"-DBRAYNS_VRPN_ENABLED=TRUE"
		    ];

	doCheck = true;
	checkPhase = ''
		
		export LD_LIBRARY_PATH=''${PWD}/lib/:${nvidia-drivers}/lib:${cudatoolkit92}/lib/:${optix}/lib:''${LD_LIBRARY_PATH}
		export LSAN_OPTIONS="suppressions=../../.lsan_suppressions.txt"
		export CUDA_VISIBLE_DEVICES=0
		make -j Brayns-tests
	'';
	enableParallelBuilding = true;
	 checkTarget="Brayns-tests";


}
