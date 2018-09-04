{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, cmake
, boost
, brion
, ispc
}:

stdenv.mkDerivation rec {
    name = "emsim-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost brion ispc ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/EMSim";
        rev = "ed3b5ae6dc68bfa0025cd1c43025021759561986";
        sha256 = "0h38d5mgg9apgnbfk35ny199xnhz5m7gx079x2k9v0ldx80xfvan";
    };
    cmakeFlags = [
        "-DGLM_INSTALL_ENABLE=OFF"
    ];

    enableParallelBuilding = true;
}
