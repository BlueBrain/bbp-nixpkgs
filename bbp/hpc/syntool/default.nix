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
        rev = "55570c9196dfc5ee87b5270e7c181fa6b88ee54c";
        sha256 = "1mw047xds18dmmiyd0n2xjpbnh2i1w5d43b0m0l75msddfwzp59m";
    };


    buildInputs = [ boost hdf5 ];

    nativeBuildInputs = [ cmake python ];
}

