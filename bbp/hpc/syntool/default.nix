{ stdenv
, fetchgitPrivate
, boost
, hdf5
, cmake
, python
}:

stdenv.mkDerivation rec {
    name = "syn-tool-${version}";
    version = "0.1";


    src = fetchgitPrivate {
        url = "ssh://bbpcode.epfl.ch/hpc/synapse-tool";
        rev = "b027622a73e00a30dd930e7ebcca447496b8b3f1";
        sha256 = "0jxaw8bdv6msdlqbr0bv8w961qw5jg0wlhykzgsqrjz9gy8p3pz0";
    };


    buildInputs = [ boost hdf5 ];

    nativeBuildInputs = [ cmake python ];
}

