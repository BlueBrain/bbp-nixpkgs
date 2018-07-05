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
    version = "0.1.0-201806";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-MorphologySynthesis";
        rev = "cd18ca936bde2c76d7d38cae0b23f2980f1aeff7";
        sha256 = "1px0hmh2r2wzqgxifn2l57ywfyqlgr1yvklr5hks2qdcpda1dvim";
    };

    enableParallelBuilding = true;
}
