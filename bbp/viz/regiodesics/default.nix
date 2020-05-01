{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, cmake
, openscenegraph
, boost
, opengl
}:

stdenv.mkDerivation rec {
    name = "regiodesics";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost openscenegraph opengl ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Regiodesics";
        rev = "23b6a0becc85addedccadb01fe5cbf07bed2d148";
        sha256 = "0zd64nzd2dqld8acjjra8kzpn220biqaqw7r1i8achr3wpgx72vq";
    };

    enableParallelBuilding = true;
}
