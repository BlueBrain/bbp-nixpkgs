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
    version = "0.1.0-201806";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-BrainAtlas";
        rev = "f8f9b249890ee540eed9210f20206eaeb6c862d4";
        sha256 = "0xsbsgifmsyrrk0jn33n5x5s03wgfaa682mpqhbkm56pawlx2iq0";
    };

    enableParallelBuilding = true;
}
