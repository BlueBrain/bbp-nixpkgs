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
        rev = "ee9e8d37d59ae6b25e1f33589668b37813fd982a";
        sha256 = "0m3zzra37grpbgqnazqmyvbb0dd277n20i44lbajb6k6zfbhy1vm";
    };
    cmakeFlags = [
        "-DGLM_INSTALL_ENABLE=OFF"
    ];

    enableParallelBuilding = true;
}
