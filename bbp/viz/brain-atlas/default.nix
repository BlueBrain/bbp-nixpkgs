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
        rev = "edad1de2eba8a77c62d7cd6c76159830db70a8ef";
        sha256 = "0h6hr23243l0vhdypyqd2ds1sb91smjs1wmvn5srzbpis6jkqdxp";
    };

    enableParallelBuilding = true;
}
