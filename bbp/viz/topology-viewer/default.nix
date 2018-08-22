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
        rev = "17299db9285b79ce2e5f067454668ce84f4ec82d";
        sha256 = "0s52j3lmy6xzzafj8f8fl38z805dvhmb4zlx2k1qxpsc22zwhyxd";
    };
    enableParallelBuilding = true;

}
