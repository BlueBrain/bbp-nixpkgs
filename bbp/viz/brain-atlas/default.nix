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
    name = "brain-atlas-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-BrainAtlas";
        rev = "0d052a3de12bebc75f09551d95802cbcdf10d150";
        sha256 = "038aa4fkc7f1cjwz5v5zcvdzcjg0gzii19blpyv2khh8wdlmbqhg";
    };

    enableParallelBuilding = true;
}
