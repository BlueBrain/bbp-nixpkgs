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
        rev = "b7461f52182e682c5bb06eac199adbe9d219bfd4";
        sha256 = "1crpqbpljph5967ss4iv1wcmf4g5r0zm8mvfcv95rviw6bynvsqc";
    };
    enableParallelBuilding = true;

}
