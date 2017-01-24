{ stdenv
, fetchFromGitHub
, cmake
, pkgconfig
, ispc
, embree
, doxygen
, tbb
, mesa
, freeglut
, readline
, qt4
}:


stdenv.mkDerivation rec {
	name = "ospray-${version}";
	version = "1.1.2";

	buildInputs = [ pkgconfig embree tbb ispc mesa freeglut readline qt4 ];

	nativeBuildInputs = [ doxygen cmake ];

	src = fetchFromGitHub {
		owner = "ospray";
		repo  = "ospray";
		rev = "95ccc33fa023e9d3bc51253980dd1fa18215963b";
		sha256 = "0f1zjdpgx7hda3swlm2mr2acr24fb4f70y2bnqpdlsi3ns4p88wi";
	};



    cmakeFlags = [ "-DOSPRAY_USE_EXTERNAL_EMBREE=TRUE"      # disable bundle embree
                   "-DOSPRAY_ZIP_MODE=OFF"                   #disable bundle dependencies
                   "-Dembree_DIR=${embree}" 
                   "-DEMBREE_MAX_ISA=AVX2"
                   "-DTBB_ROOT=${tbb}"
                   ];


	outputs = [ "out" "doc" ];

    propagatedBuildInputs = [ ispc  embree ];

	enableParallelBuilding = true;


}
