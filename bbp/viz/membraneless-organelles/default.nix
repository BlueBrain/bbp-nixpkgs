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
    version = "0.1.0-201806";

    buildInputs = [ stdenv pkgconfig cmake boost highfive vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-MembranelessOrganelles";
        rev = "6f97214b48a5295867d6a7426716b2fe9dfb9c66";
        sha256 = "0mmbc8j67jpacrk36llzhd597ygldksq2nsxvirkc2gc89a0xnyk";
    };

    enableParallelBuilding = true;
}
