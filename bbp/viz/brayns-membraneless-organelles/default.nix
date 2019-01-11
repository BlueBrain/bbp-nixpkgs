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
    name = "brayns-membraneless-organelles-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost highfive vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-MembranelessOrganelles";
        rev = "5f1e4dc9e4ea59b25189a5481d212f40e2f3f967";
        sha256 = "1j52g05fpsr0k4x6s8m37kmym0822zl3025vrqkq2xy345nr486k";
    };

    enableParallelBuilding = true;
}
