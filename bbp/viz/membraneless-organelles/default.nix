{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, boost
, cmake
, highfive
, vmmlib
, brayns
}:

stdenv.mkDerivation rec {
    name = "membraneless-organelles-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost highfive vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-MembranelessOrganelles";
        rev = "c31dc2a59dce4c4d01e2899a8bd0b4ae04ee80b7";
        sha256 = "14bxpyw244pnhnv3qxk3nyqwz1bz97wl314jl4aj374cpq21hw52";
    };

    enableParallelBuilding = true;
}
