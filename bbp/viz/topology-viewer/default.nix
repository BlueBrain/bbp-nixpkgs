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
        rev = "9b6131616387e9e28010be011f0fcd9ab64f7cb1";
        sha256 = "19irszrwblfkrp5ail9bcyvhsnlcfin0cbg3m7p4vjkam5pn56lw";
    };
    enableParallelBuilding = true;

}
