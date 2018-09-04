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
    name = "morphology-synthesis-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-MorphologySynthesis";
        rev = "87b2b367fe9b5cf81023b2500fe2107deff10d09";
        sha256 = "1mfivsqbhzjah29dy9zr7chw2j7iqd304yf8ldflvpmsxadh4h36";
    };

    enableParallelBuilding = true;
}
