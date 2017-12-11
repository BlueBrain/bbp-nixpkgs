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
		version = "1.4.1";
		rev = "216110455e4583190f3d8c3e52797f2769f91194";
		sha256 = "0jv0pccbn212afy41jpz3r6gbwbiy2lrm3lx7c36c3mkdhcavw4c";
	};

	ospray-info = if (devel) then devel-info else release-info;

in
stdenv.mkDerivation rec {
	name = "ospray-${version}";
	version = ospray-info.version;

	buildInputs = [ pkgconfig embree tbb ispc mesa freeglut readline qt4 mpi ];

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
                   "-DTBB_ROOT=${tbb}"
                   "-DOSPRAY_MODULE_MPI=ON"
                   "-DCMAKE_INSTALL_INCLUDEDIR=include/"
                   "-DCMAKE_INSTALL_LIBDIR=lib/"
                   ];


	outputs = [ "out" "doc" ];

    propagatedBuildInputs = [ ispc embree ];

    enableParallelBuilding = true;


}
