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
		rev = "bcfaf3e4f80e4655475a065942bc9828e6c9a4ee";
		sha256 = "0x591023qqxisx568d4sph2mkzgq708ir2r425wyli2z5yzw4pas";
	};

    cmakeFlags = [ "-DOSPRAY_ZIP_MODE=OFF"                   #disable bundle dependencies
                   "-Dembree_DIR=${embree}" 
                   "-DOSPRAY_APPS_EXAMPLEVIEWER=OFF"
                   "-DOSPRAY_ENABLE_APPS=OFF"
                   "-DOSPRAY_ENABLE_TUTORIALS=OFF"
                   "-DTBB_ROOT=${tbb}"
                   "-DOSPRAY_MODULE_MPI=ON"
                   "-DCMAKE_INSTALL_INCLUDEDIR=include/"
                   "-DCMAKE_INSTALL_LIBDIR=lib/"
                   ];

    outputs = [ "out" "doc" ];
    propagatedBuildInputs = [ ispc embree ];
    enableParallelBuilding = true;
}
