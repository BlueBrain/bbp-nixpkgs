{ stdenv
, fetchFromGitHub
, cmake
, parmetis
, gfortran
, perl
, openblas
, boost
, mpi ? null
, defaultPackages ? false
, withZoltan ? false
, withKokkos ? false
, withTeuchos ? false
, buildSharedLibs ? false
, yaml-cpp
}:

let
    pluginNames =
        "-with"
        + (if (mpi != null) then "-mpi" else "")
        + (if withZoltan then "-zoltan" else "")
        + (if withKokkos then "-kokkos" else "")
        + (if withTeuchos then "-teuchos" else "");
in
stdenv.mkDerivation rec {
    name = "trilinos${pluginNames}-${version}";
    version = "13.0.0-master";

    src = fetchFromGitHub {
        owner = "trilinos";
        repo = "Trilinos";
        rev = "996e8c2c2423564955e16a322b8b786121c5d2f0";
        sha256 = "1nmpf22lbf6wf3jqlzc9bc2iw433pblp9fizxg4szp22hbl33h6i";
    };

    preConfigure = ''
        export FC=gfortran;
    '';

    buildInputs = [
        boost
        gfortran
        mpi
        openblas
        parmetis
        yaml-cpp
    ];

    cmakeFlags = [
        "-DTPL_BLAS_LIBRARIES:STRING=-lopenblas"
        "-DTPL_ENABLE_Netcdf=OFF"
        "-DTPL_ENABLE_ParMETIS:BOOL=ON"
        "-DTPL_ENABLE_X11=OFF"
        "-DTPL_ENABLE_yaml-cpp:BOOL=ON"
        "-DTPL_LAPACK_LIBRARIES:SRING=-lopenblas"
        "-DTrilinos_ENABLE_ALL_PACKAGES=${if (defaultPackages) then "ON" else "OFF"}"
    ]
    ++ stdenv.lib.optional (mpi != null) [ "-DTPL_ENABLE_MPI=ON" ]
    ++ stdenv.lib.optional (withZoltan) [ "-DTrilinos_ENABLE_Zoltan=TRUE" ]
    ++ stdenv.lib.optional (withKokkos) [ "-DTrilinos_ENABLE_Kokkos=TRUE" ]
    ++ stdenv.lib.optional (withTeuchos) [
        "-DTrilinos_ENABLE_Teuchos:BOOL=ON"
        "-DTrilinos_ENABLE_TeuchosComm:BOOL=ON"
        "-DTrilinos_ENABLE_TeuchosNumerics:BOOL=ON"
        "-DTrilinos_ENABLE_TeuchosParameterList:BOOL=ON"
        "-DTrilinos_ENABLE_TeuchosParser:BOOL=ON"
    ]
    ++ stdenv.lib.optional buildSharedLibs [ "-DBUILD_SHARED_LIBS:BOOL=ON" ]
    ;

    nativeBuildInputs = [
        cmake
        perl
    ];

    passthru = {
        src = src;
        mpi = mpi;
        buildSharedLibs = buildSharedLibs;
    };

    crossAttrs = {
        preConfigure = ''
            export FC="${stdenv.cross.config}-gfortran"
        '';
    };
}
