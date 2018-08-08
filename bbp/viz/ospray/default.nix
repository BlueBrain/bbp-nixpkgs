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
		version = "1.5-devel";
		rev = "67a827eef56136aa49acae013889a1050d6c27de";
		sha256 = "1ap3n1444j3b70sv16l5hc62nn3mxiisz00gdlxql8yc43d533bx";
	};

	release-info = {
		version = "1.5.0";
		rev = "41559ef427e20fe6d169ea1fb8b43569f9b9be98";
		sha256 = "01fbsbfajy36lkv82r1xj1iwfiizva08gs1852vwij29sd6cq4sn";
	};

	ospray-info = if (devel) then devel-info else release-info;

in
stdenv.mkDerivation rec {
	name = "ospray-${version}";
	version = ospray-info.version;

	buildInputs = [ pkgconfig glfw embree tbb ispc mesa freeglut readline mpi ];

	nativeBuildInputs = [ doxygen cmake ];

	src = fetchFromGitHub {
		owner = "Bluebrain";
		repo  = "OSPRay";
		rev = ospray-info.rev;
		sha256 = ospray-info.sha256;
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
