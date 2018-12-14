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
        rev = "2b7357e762aba1b753da49d727c70ab22e04c145";
        sha256 = "0gr32wgdkd7b6f87m75hyxxi7fk7ym7yyqrrmx58bm9yqs5qwfh4";
    };
    enableParallelBuilding = true;

}
