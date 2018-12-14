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
    name = "brain-atlas-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-BrainAtlas";
        rev = "60d1630d3f6c0004a8ed9de44c852c3dc0991694";
        sha256 = "0gvg6g8ih7qivgyzmixj4wbnx8b7qyb201d0bchwfhb51mm9fpmn";
    };

    enableParallelBuilding = true;
}
