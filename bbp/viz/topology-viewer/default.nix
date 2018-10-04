{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, boost
, cmake
, highfive
, vmmlib
, brayns
}:

stdenv.mkDerivation rec {
    name = "topology-viewer-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost highfive vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-TopologyViewer";
        rev = "ec4bcf1a231bc7c4c066d069ad0bf65c47803b2e";
        sha256 = "1dph14fd181a07z30i2n57plf3wc18d1x9lsbbh9g26iij3ixxg8";
    };
    enableParallelBuilding = true;

}
