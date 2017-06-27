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
        rev = "fa0c1b7f1e938ad2630dc473261bccddb88a3043";
        sha256 = "0n2mpll3ar5ah0hk12cv3bf7q13f85nlb6b2702myl6gagxxj4ax";
    };


    buildInputs = [ boost hdf5 ];

    nativeBuildInputs = [ cmake python ];
}

