{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, cmake
, boost
, vmmlib
, brayns
}:

stdenv.mkDerivation rec {
    name = "morphology-synthesis-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-MorphologySynthesis";
        rev = "61fc766620a39ff5d957c1d896858b4bef5b6fb8";
        sha256 = "1d51cv3289sii4j1acj8xmmmv4016rym4sfxakkbv1brad9pfdpr";
    };

    enableParallelBuilding = true;
}
