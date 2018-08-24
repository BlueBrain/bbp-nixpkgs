{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, boost
, cmake
, vmmlib
, brayns
}:

stdenv.mkDerivation rec {
    name = "diffusion-tensor-imaging-${version}";
    version = "0.1.0-201808";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-DTI";
        rev = "db06fa1c213864efd1219fad79dca63f6dcf357c";
        sha256 = "00qyhg57a893diiyszwhdqavqhpxa60bbjv65q4j73c5zp6b7ivs";
    };

    enableParallelBuilding = true;
}

