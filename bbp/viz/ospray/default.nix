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
		version = "1.4.0";
		rev = "561eadfe21334ef1d33161947ead416a09040266";
		sha256 = "1apws48m6kvwv1ak4id52d7csr7qyl3qmmvkik52jxpiw3w43vgh";
	};

	ospray-info = if (devel) then devel-info else release-info;

in
stdenv.mkDerivation rec {
	name = "ospray-${version}";
	version = ospray-info.version;

	buildInputs = [ pkgconfig embree tbb ispc mesa freeglut readline qt4 mpi ];

	nativeBuildInputs = [ doxygen cmake ];

	src = fetchFromGitHub {
		owner = "BlueBrain";
		repo  = "ospray";
		rev = ospray-info.rev;
		sha256 = ospray-info.sha256;
	};



    cmakeFlags = [ "-DOSPRAY_ZIP_MODE=OFF"                   #disable bundle dependencies
                   "-Dembree_DIR=${embree}" 
                   "-DEMBREE_MAX_ISA=AVX2"
                   "-DTBB_ROOT=${tbb}"
                   "-DOSPRAY_MODULE_MPI=ON"
                   ];


	outputs = [ "out" "doc" ];

    propagatedBuildInputs = [ ispc embree ];

    enableParallelBuilding = true;


}
