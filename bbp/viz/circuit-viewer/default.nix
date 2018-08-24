{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, boost
, cmake
, vmmlib
, brayns
}:

stdenv.mkDerivation rec {
    name = "circuit-viewer-${version}";
    version = "0.1.0-201808";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-CircuitViewer";
        rev = "de9098271230d56f1ef2d65879eaca07a1cd32e6";
        sha256 = "1p70q7isrj32q9w0xnrw2f30f72irrn63apb89b35qcn9p3f4093";
    };

    enableParallelBuilding = true;
}

