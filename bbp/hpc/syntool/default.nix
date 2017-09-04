{ stdenv
, fetchgitPrivate
, boost
, hdf5
, cmake
, python
}:

stdenv.mkDerivation rec {
    name = "syn-tool-${version}";
    version = "0.1-dev201709";


    src = fetchgitPrivate {
        url = "ssh://bbpcode.epfl.ch/hpc/synapse-tool";
        rev = "05bc59deab7f74be634a64ab7e3f8d1ac3992178";
        sha256 = "1qmmz5ljy5hvsn4pk59qdip1mpavcy4yp11sfdvdr0rxb4av5183";
    };


    buildInputs = [ boost hdf5 ];

    nativeBuildInputs = [ cmake python ];
}

