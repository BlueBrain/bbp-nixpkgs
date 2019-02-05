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
        rev = "aed6dc70da3db7f258a6e44021105014f9e76d38";
        sha256 = "02r6xax1zzarm7dbkakc1jc9vjllmcn5d4xya5bdmcp79xk72m33";
    };

    enableParallelBuilding = true;
}
