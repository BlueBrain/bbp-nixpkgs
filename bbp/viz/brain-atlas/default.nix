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
        rev = "071292f84db314f108af1a0f7459d1ddaac6670b";
        sha256 = "0hq32hz2y37cs9imbc5ah5zhkzx3niwp2a0mr8gf67dvng4yjd36";
    };

    enableParallelBuilding = true;
}
