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
}:

stdenv.mkDerivation rec {
	name = "ospray-${version}";
	version = "latest";
	buildInputs = [ pkgconfig glfw embree tbb ispc mesa freeglut readline mpi ];

	nativeBuildInputs = [ doxygen cmake ];

	src = fetchFromGitHub {
		owner = "ospray";
		repo  = "ospray";
		rev = "5a0e7f99fe810c563ba7f105da584e2c23eb4c6b";
		sha256 = "1qigdwf3s8ii0iwawmrm6ma1galhwf3z6ds4fi27mx80fypxlv87";
	};

    cmakeFlags = [ "-DOSPRAY_ZIP_MODE=OFF"                   #disable bundle dependencies
                   "-Dembree_DIR=${embree}" 
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
