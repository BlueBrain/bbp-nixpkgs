{ stdenv
, fetchgitPrivate
, boost
, hdf5
, cmake
, python
}:

stdenv.mkDerivation rec {
    name = "syn-tool-${version}";
    version = "0.0.1";


    src = fetchgitPrivate {
        url = "ssh://bbpcode.epfl.ch/hpc/synapse-tool";
        rev = "8b3ca1dca1e729f08ffd39c42a3717a43743c1ed";
        sha256 = "0i17ylghizhi9iil5bfywqid6wswzgp4hyql039n7cjz0qj9k9a7";
    };


    buildInputs = [ boost hdf5 ];

    nativeBuildInputs = [ cmake python ];
}

