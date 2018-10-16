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
    name = "brain-atlas-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-BrainAtlas";
        rev = "bd1b16222be71161366586657d4ec9f5472e18db";
        sha256 = "0bg301cdkkwrhfpgj9x7cj1jxgmywanfq0i8h50mjhxajwaqhyam";
    };

    enableParallelBuilding = true;
}
