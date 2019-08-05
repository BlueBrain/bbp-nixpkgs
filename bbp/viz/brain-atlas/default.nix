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
        rev = "ce417691d13d7f8c45cf6720cef9e7130281755f";
        sha256 = "0zp3fzbd8rk8qrs1yjzxhh3101cqpiv805mfd6ambz9ci97cnixx";
    };

    enableParallelBuilding = true;
}
