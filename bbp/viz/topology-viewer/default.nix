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
        rev = "58a61253c1e33aea7248c7894398035a36608674";
        sha256 = "1j4niys9xfsq3w7z1b3dwlhsl0zhh4621dgpv4lssaswmaf4q0zl";
    };
    enableParallelBuilding = true;

}
