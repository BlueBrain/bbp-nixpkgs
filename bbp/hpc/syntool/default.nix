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
        rev = "a874657cfdb73d09aa04e01e81c2c0ba698b7bbe";
        sha256 = "0l561xslfn6bl2q82clddx7jx5h63h7kli8damaddlrw6rgd5di7";
    };


    buildInputs = [ boost hdf5 ];

    nativeBuildInputs = [ cmake python ];
}

