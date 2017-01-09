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
, withZoltan ? true
}:


let 
    pluginNames = "-with"
                  + (if (mpi != null) then "-mpi" else "")
                  + (if (withZoltan) then "-zoltan" else "");
in
stdenv.mkDerivation rec {
    name = "trilinos${pluginNames}-${version}";
    version = "12.10.1";

    src = fetchFromGitHub {
        owner = "trilinos";
        repo = "Trilinos";
        rev = "f94b7be34e20e8ac35a1f475f58231f651a2f5c8";
        sha256 = "1505kv04lmsacv260q2qpla8s6j94rcw5bnqxxyh15r1ficnjhxp";
    };


    preConfigure = ''
        export FC=gfortran;
    '';

    buildInputs = [ mpi boost openblas parmetis gfortran ];
   

    cmakeFlags = [ 
                    "-DTPL_BLAS_LIBRARIES:STRING=-lopenblas"
                    "-DTPL_LAPACK_LIBRARIES:SRING=-lopenblas"
                    "-DTrilinos_ENABLE_ALL_PACKAGES=${if (defaultPackages) then "ON" else "OFF"}" 
                    "-DTPL_ENABLE_Netcdf=OFF"
                    "-DTPL_ENABLE_X11=OFF"
                    "-DTPL_ENABLE_ParMETIS:BOOL=ON"
                ] 
                ++ (stdenv.lib.optional) (mpi != null) [ "-DTPL_ENABLE_MPI=ON" ]
                ++ (stdenv.lib.optional) (withZoltan) [ "-DTrilinos_ENABLE_Zoltan=TRUE" ];
 
    nativeBuildInputs = [ cmake perl  ];


    passthru = {
        src = src;
    };

    crossAttrs = {
        preConfigure = ''
            export FC="${stdenv.cross.config}-gfortran"
        ''; 
        

    };

}
