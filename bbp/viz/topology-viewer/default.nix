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
    version = "0.1.0-201806";

    buildInputs = [ stdenv pkgconfig cmake boost highfive vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-TopologyViewer";
        rev = "0eb25a824360ebd496c0cf7e1cc0ec486131e0f4";
        sha256 = "0irq9x3vr6sgggp88sa4dfj82jsxis4fpy9vkknsvala0ab9svak";
    };

    enableParallelBuilding = true;
}
