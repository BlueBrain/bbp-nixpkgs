{ stdenv
, gfortran
, fetchurl
, mpi
, cmake
, blas
, lapack
}:


stdenv.mkDerivation rec {
    name = "scalapack-${version}";
    version = "2.0.2";

    src = fetchurl {
        url = "http://www.netlib.org/scalapack/scalapack-${version}.tgz";
        sha256 = "0p1r61ss1fq0bs8ynnx7xq4wwsdvs32ljvwjnx6yxr8gd6pawx0c";
    };

    buildInputs = [ gfortran mpi cmake blas lapack ];

    cmakeFlags = [  
                    "-DBLAS_DIR=${blas}" 
                    "-DBLAS_LIBRARIES=${blas}/lib/libopenblas.so"
                    "-DBLAS_FOUND=TRUE"
                    "-DLAPACK_DIR=${blas}" 
                    "-DLAPACK_LIBRARIES=${lapack}/lib/libopenblas.so"
                    "-DLAPACK_FOUND=TRUE"

                 ];

    enableParallelBuilding = true;
}
