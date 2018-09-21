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
        rev = "89e2b8c07b72590d4d28a72f11040891b8e4d693";
        sha256 = "1hpqi89bi3fg9iif6aq59ihhc959qnhaii619yjda1bwwdqi618q";
    };
    enableParallelBuilding = true;

}
