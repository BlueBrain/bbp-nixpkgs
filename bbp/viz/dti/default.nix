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
        rev = "df7e5217a98299ae0701b376a3dc07d38d8966fe";
        sha256 = "08p3bv16pyvgrpaczdi2gg5gvnkbb7krcrsbnr74rd25r097bmh2";
    };

    enableParallelBuilding = true;
}

