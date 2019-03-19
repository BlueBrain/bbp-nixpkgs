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
        rev = "07b85bac8fa846e23c92acd170af64db281627bd";
        sha256 = "1x153zy2aaw2r90vnkzcbvy6nj5c28gnr2ji09pkrrcsag6anwmv";
    };

    enableParallelBuilding = true;
}
