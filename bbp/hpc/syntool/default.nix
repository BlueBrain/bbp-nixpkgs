{ stdenv
, fetchgitPrivate
, boost
, hdf5
, highfive
, cmake
, python
}:

stdenv.mkDerivation rec {
    name = "syn-tool-${version}";
    version = "0.1-dev201709";


    src = fetchgitPrivate {
        url = "ssh://bbpcode.epfl.ch/hpc/synapse-tool";
        rev = "f02fff48867b3acd9162515fdc224f1b8f48e9df";
        sha256 = "15iarkk9fsama2mdj0ji5zcknf8r9z6490fcinznrn8fvv1lnd0z";
    };


    buildInputs = [ boost hdf5 highfive ];

    nativeBuildInputs = [ cmake python ];
}

