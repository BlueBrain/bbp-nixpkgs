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
        rev = "ae307a48e836d17eb6c591d9f92e2875f2e7b04e";
        sha256 = "0d2qimjk7xhz9q3frn03p12580jcjc7j2ijdws9vxd97kq9h2x9s";
    };

    enableParallelBuilding = true;
}
