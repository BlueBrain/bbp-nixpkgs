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
    name = "diffusion-tensor-imaging-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-DTI";
        rev = "09be10d86eaa65105e14a0f85debd10c58e2edc0";
        sha256 = "1c9a4kdkb0a3nr3nfpkcgva4wb7g2dqpmscg3dswni0ryx3kliil";
    };

    enableParallelBuilding = true;
}

