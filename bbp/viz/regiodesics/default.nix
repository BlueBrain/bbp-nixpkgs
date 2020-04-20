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
        rev = "22ee7f37f3f47fa0b98f71b703f6f711e0dc0c14";
        sha256 = "17c1a729v8gkr8gx6qpw3852x5y07hsb73lnnlzw50skz2dy4qz2";
    };

    enableParallelBuilding = true;
}
