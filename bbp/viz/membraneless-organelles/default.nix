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
        rev = "6d2dc28072110e2e1ad38fe4ff4fa8c501d07388";
        sha256 = "1vhhfn0cxr4yrcrb62cwxlksdpgg1ka23nbd2r297215mfd4kq5q";
    };

    enableParallelBuilding = true;
}
