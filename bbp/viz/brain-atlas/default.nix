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
        rev = "5faa5147e31d33f4ae6bb31d0c1f9e7f4792ae69";
        sha256 = "19xv5xckx423hj082jvczif5bvmbldlckc3nqr6gjw233nx1q2ls";
    };

    enableParallelBuilding = true;
}
