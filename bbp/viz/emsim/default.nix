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
        rev = "6edd121049dde88f9821ce8d0a6859c9b71df258";
        sha256 = "0gg65rcp2ivp0jj2b6fm7qi17g6m881z4srqrsb7kvi30iknz5kw";
    };
    cmakeFlags = [
        "-DGLM_INSTALL_ENABLE=OFF"
    ];

    enableParallelBuilding = true;
}
