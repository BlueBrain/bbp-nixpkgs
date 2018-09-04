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
	version = "1.5.0";

	buildInputs = [ pkgconfig glfw embree tbb ispc mesa freeglut readline mpi ];

	nativeBuildInputs = [ doxygen cmake ];

	src = fetchFromGitHub {
		owner = "Bluebrain";
		repo  = "OSPRay";
		rev = "41559ef427e20fe6d169ea1fb8b43569f9b9be98";
		sha256 = "01fbsbfajy36lkv82r1xj1iwfiizva08gs1852vwij29sd6cq4sn";
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
