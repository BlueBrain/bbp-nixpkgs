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
        rev = "26c82e5872677ec5ff8d5e33ca765725a775fa5e";
        sha256 = "1pppl1g2hhdnj0jn02rwrb47bsxvph92k8wkc7vpr296sg1jky9d";
    };


    buildInputs = [ boost hdf5 ];

    nativeBuildInputs = [ cmake python ];
}

