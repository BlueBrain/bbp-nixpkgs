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
        rev = "063d6fa703c8c1a70b5dd9ed78511bdb1cac9ecc";
        sha256 = "0qv9gb0yjcr18n0956ss7pbi75c5lqjjcpzfa21xjcgnsf7pm0a7";
    };

    enableParallelBuilding = true;
}
