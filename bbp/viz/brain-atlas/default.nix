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
        rev = "195d54392209b55be3e4bcd1d3b3b9321450af66";
        sha256 = "1mdkjirqcy1d93apapv8pag0nm9lh7f9v1kqq3lnjvqp7ah0m6lh";
    };

    enableParallelBuilding = true;
}
