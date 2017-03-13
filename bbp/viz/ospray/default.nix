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
	version = "1.2.0";

	buildInputs = [ pkgconfig embree tbb ispc mesa freeglut readline qt4 ];

	nativeBuildInputs = [ doxygen cmake ];

	src = fetchFromGitHub {
		owner = "ospray";
		repo  = "ospray";
		rev = "a6798efceb752d4b992449f50cc931a44b33baea";
		sha256 = "0jabi1j09py1g0c5czil5swwx0r8153hhymdp2a9l78z738jrz6b";
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
