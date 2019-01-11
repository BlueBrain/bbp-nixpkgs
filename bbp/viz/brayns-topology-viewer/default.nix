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
        rev = "a1986ac44873fa52e6c4c982282f2022462f5e0c";
        sha256 = "0pbmy32b7zzgdyifpm2n945kv8ahg9433rkd30z7rk8d1prvzvkb";
    };
    enableParallelBuilding = true;

}
