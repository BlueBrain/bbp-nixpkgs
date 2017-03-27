{ clangStdenv
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


clangStdenv.mkDerivation rec {
	name = "ospray-${version}";
	version = "1.2.1";

	buildInputs = [ pkgconfig embree tbb ispc mesa freeglut readline qt4 ];

	nativeBuildInputs = [ doxygen cmake ];

	src = fetchFromGitHub {
		owner = "ospray";
		repo  = "ospray";
		rev = "be966e3454bbb386a7dd95a5003da536fcb334f6";
		sha256 = "097d01cfqmwdb4zrrfvvlv246xfwc4b2vhgpm7xdcr3rvn09dcfk";
	};



    cmakeFlags = [ "-DOSPRAY_USE_EXTERNAL_EMBREE=TRUE"      # disable bundle embree
                   "-DOSPRAY_ZIP_MODE=OFF"                   #disable bundle dependencies
                   "-Dembree_DIR=${embree}" 
                   "-DEMBREE_MAX_ISA=${embree.instruction_set}"
                   "-DTBB_ROOT=${tbb}"
                   ];


	outputs = [ "out" "doc" ];

	propagatedBuildInputs = [ ispc  embree ];

	enableParallelBuilding = true;


}
