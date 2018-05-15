{ stdenv
, fetchFromGitHub
, cmake
, pkgconfig
, ispc
, embree
, doxygen
, tbb
, glfw
, mesa
, freeglut
, readline
, mpi
, devel ? false
}:

let 
	devel-info = {
		version = "1.4-devel";
		rev = "e629d949e26db22cf33e1e19b609319c2389a828";
		sha256 = "0srrj6147bgfrlkkicfw3km8y6ipjam86qnkvijl47qfqgfxa7xc";
	};

	release-info = {
		version = "1.4.2";
		rev = "b3895aa7441b54166df005f20578fb5106226bb9";
		sha256 = "1ap3n1444j3b70sv16l5hc62nn3mxiisz00gdlxql8yc43d533bx";
	};

	ospray-info = if (devel) then devel-info else release-info;

in
stdenv.mkDerivation rec {
	name = "ospray-${version}";
	version = ospray-info.version;

	buildInputs = [ pkgconfig glfw embree tbb ispc mesa freeglut readline mpi ];

	nativeBuildInputs = [ doxygen cmake ];

	src = fetchFromGitHub {
		owner = "ospray";
		repo  = "ospray";
		rev = ospray-info.rev;
		sha256 = ospray-info.sha256;
	};



    cmakeFlags = [ "-DOSPRAY_ZIP_MODE=OFF"                   #disable bundle dependencies
                   "-Dembree_DIR=${embree}" 
                   "-DEMBREE_MAX_ISA=AVX2"
                   "-DOSPRAY_ENABLE_APPS=FALSE"
                   "-DOSPRAY_MODULE_MPI_APPS=FALSE"
                   "-DTBB_ROOT=${tbb}"
                   "-DOSPRAY_MODULE_MPI=ON"
                   "-DCMAKE_INSTALL_INCLUDEDIR=include/"
                   "-DCMAKE_INSTALL_LIBDIR=lib/"
                   ];


	outputs = [ "out" "doc" ];

    propagatedBuildInputs = [ ispc embree ];

    enableParallelBuilding = true;


}
