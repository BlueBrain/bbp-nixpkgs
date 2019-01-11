{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, cmake
, boost
, vmmlib
, brayns
}:

stdenv.mkDerivation rec {
    name = "brayns-morphology-synthesis-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-MorphologySynthesis";
        rev = "509e2e9bc5dd4d19b559cce4b6d99fa9b823fbe2";
        sha256 = "0wpa3pl0f5mnwb180r55jkiy8wqdajlqivx11p9dgf6p737jzanr";
    };

    enableParallelBuilding = true;
}
