{ stdenv
, fetchFromGitHub
, cmake
, pkgconfig
, ispc
, embree
, doxygen
, tbb
, readline
, mpi
}:

stdenv.mkDerivation rec {
	name = "ospray-${version}";
	version = "latest";
	buildInputs = [ pkgconfig embree tbb ispc  readline mpi ];

	nativeBuildInputs = [ doxygen cmake ];

	src = fetchFromGitHub {
		owner = "ospray";
		repo  = "ospray";
		rev = "afca4d6ef536c04081626f2dce0834d76b9a282c";
		sha256 = "0kgzbv4x1db9aaifd5sjir6vg7k0n7vzj2l9q3nglqw7bgq2ycjg";
	};

    cmakeFlags = [ "-DOSPRAY_ZIP_MODE=OFF"                   #disable bundle dependencies
                   "-Dembree_DIR=${embree}" 
                   "-DTBB_ROOT=${tbb}"
                   "-DOSPRAY_MODULE_MPI=ON"
                   "-DCMAKE_INSTALL_INCLUDEDIR=include/"
                   "-DCMAKE_INSTALL_LIBDIR=lib/"
                   "-DOSPRAY_ENABLE_APPS=FALSE"
                   "-DOSPRAY_APPS_EXAMPLEVIEWER=OFF"
                   "-DOSPRAY_MODULE_MPI_APPS=FALSE"
                   "-DOSPRAY_ENABLE_APPS=OFF"
                   "-DOSPRAY_ENABLE_TUTORIALS=OFF"
                   ];

    outputs = [ "out" "doc" ];
    propagatedBuildInputs = [ ispc embree ];
    enableParallelBuilding = true;
}
