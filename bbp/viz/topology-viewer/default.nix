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
        rev = "e1ff6383ff0a3051cb3b596a1082debf37945225";
        sha256 = "054hcbmbw0077f7y121an2q49mj3wm68v91qpssxbbc7kzm733am";
    };

    enableParallelBuilding = true;
}
