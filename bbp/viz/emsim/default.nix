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
        rev = "894ca5f59cc894783a18fd63d41417074a2ccf04";
        sha256 = "162prpczabmy1v88k79snhbqnvv9dbgxvbqk72fny771fjr967rz";
    };
    cmakeFlags = [
        "-DGLM_INSTALL_ENABLE=OFF"
    ];

    enableParallelBuilding = true;
}
