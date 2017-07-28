{ stdenv
, fetchFromGitHub
, hdf5
, cmake
, mpi
, python
, zlib
, bzip2
, lz4
}:



stdenv.mkDerivation rec {
    name = "adios-${version}";
    version = "1.12.0-201707";

    src = fetchFromGitHub {
        owner = "ornladios";
        repo = "ADIOS";
        rev = "c653a9af19d71b0c8c4da173544b0c780cd21f58";
        sha256 = "0fk4jk7ncv6dfmjmf9w2gmkldyz6kgh4myk02k5n7js20xcvvcqw";
    };

    buildInputs = [ stdenv hdf5 mpi ];

    nativeBuildInputs = [ python cmake zlib bzip2 ];

    cmakeFlags = [ "-DBUILD_FORTRAN=FALSE" ];

    # cmake of ADIOS is particular and 
    # does not support well configuration by argument
    # and pick up its configuration through env var
    preConfigure = ''

        # hdf5 ADIOS prefix
        export SEQ_HDF5_DIR="${hdf5}"
        export SEQ_HDF5_LIBS="${hdf5}/lib/libhdf5.so;${hdf5}/lib/libhdf5_hl.so"

        # bzip2 adios prefix
        export BZIP2_DIR="${bzip2}"

        # lz4 adios prefix
        export LZ4_DIR="${lz4}"

        # export mpi
        export CC=mpicc
        export CXX=mpic++
    '';

}

