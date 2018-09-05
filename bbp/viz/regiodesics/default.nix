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
        rev = "d969ca2d67c60e9de223adef82127901c69a4e8c";
        sha256 = "0pfjvyam5n7ykjizx29a5a9h6z4x7dfn6gly8hlnry6ziv00lm7b";
    };

    enableParallelBuilding = true;
}
