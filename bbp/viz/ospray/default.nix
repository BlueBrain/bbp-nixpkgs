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
, qtViewer ? false
, glutViewer ? true
, volumeViewer ? false
, devel ? false
}:

let

       devel-info = {
               version = "1.4-devel";
               rev = "e629d949e26db22cf33e1e19b609319c2389a828";
               sha256 = "0srrj6147bgfrlkkicfw3km8y6ipjam86qnkvijl47qfqgfxa7xc";
       };

       release-info = {
               version = "1.3.1";
               rev = "4907ab0e25b20cb0a863927c32cea8dfc1a66433";
               sha256 = "03lv0dl15kvf04xlb8accz66i7cab299fgbd1kv6gkhm47lwr35h";
       };

       ospray-info = if (devel) then devel-info else release-info;
in
stdenv.mkDerivation rec {
	name = "ospray-${version}";
	version = ospray-info.version;

	buildInputs = [ pkgconfig embree tbb ispc mesa readline mpi ]
		++ (stdenv.lib.optionals) (qtViewer || glutViewer || volumeViewer) [ freeglut ]
		++ (stdenv.lib.optionals) (qtViewer || volumeViewer) [ qt4 ];

	nativeBuildInputs = [ doxygen cmake ];

	src = fetchFromGitHub {
		owner = "ospray";
		repo  = "ospray";
                rev = ospray-info.rev;
                sha256 = ospray-info.sha256;

	};

    cmakeFlags = [ "-DOSPRAY_USE_EXTERNAL_EMBREE=TRUE"      # disable bundle embree
                   "-DOSPRAY_ZIP_MODE=OFF"                   #disable bundle dependencies
                   "-Dembree_DIR=${embree}"
                   "-DEMBREE_MAX_ISA=AVX2"
                   "-DTBB_ROOT=${tbb}"
		   "-DOSPRAY_MODULE_MPI=${if (mpi != null) then ''TRUE'' else ''FALSE''}"
		   "-DOSPRAY_APPS_EXAMPLEVIEWER=FALSE"
		   "-DOSPRAY_APPS_QTVIEWER=${if (qtViewer) then "TRUE" else "FALSE"}"
		   "-DOSPRAY_APPS_GLUTVIEWER=${if (glutViewer) then "TRUE" else "FALSE"}"
		   "-DOSPRAY_APPS_VOLUMEVIEWER=${if (volumeViewer) then "TRUE" else "FALSE"}"
		   ''-DCMAKE_INSTALL_LIBDIR=lib/''
                   ];

    makeFlags = [ "VERBOSE=1" ];

    propagatedBuildInputs = [ ispc  embree ];

    enableParallelBuilding = true;


}
