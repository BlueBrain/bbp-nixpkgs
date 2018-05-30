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
    name = "membranelessorganelles-${version}";
    version = "0.1.0-201805";

    buildInputs = [ stdenv pkgconfig cmake boost highfive vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-MembranelessOrganelles";
        rev = "938c83f2b2a99ac75185ac45186afcec543ffb9d";
        sha256 = "13n87cclhy8k9cm5jhrzc6mivhsxadgk0bgnp48ijbnyv73sf9lw";
    };

    enableParallelBuilding = true;
}
