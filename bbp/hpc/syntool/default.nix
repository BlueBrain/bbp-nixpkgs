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
        sha256 = "1992s6ssrr6a2i85ka156g0a8cqg7qgx39d9kzwrfpi809bw7p2s";
    };


    buildInputs = [ boost hdf5 highfive ];

    nativeBuildInputs = [ cmake python ];
}

