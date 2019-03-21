{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, boost
, cmake
, vmmlib
, brayns
, libpqxx
}:

stdenv.mkDerivation rec {
    name = "diffusion-tensor-imaging-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib brayns libpqxx ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-DTI";
        rev = "8295be1fc63bf9f978f63a3ebe73565765ef077b";
        sha256 = "0rcc6xgl1h6z6az04n407ifl90d8gahz5n7ibsd9xaya6ln2asnk";
    };

    enableParallelBuilding = true;
}

