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
        rev = "727612499cd7618f2b8af69a1e2c1e98b8ab839c";
        sha256 = "1k3s41jr183w55na7zmh0670m01mn0y0jmg6g9681ci2fb9ng2r9";
    };
    enableParallelBuilding = true;

}
