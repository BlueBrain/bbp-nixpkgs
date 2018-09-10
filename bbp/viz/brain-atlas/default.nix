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
        rev = "e07e2d879c83445f0b413f5c1c3e664c309052f6";
        sha256 = "1ri6i0v2x0j6ck4njb2ai74y63izmgzkzckdnlza0v8y930x0jgn";
    };

    enableParallelBuilding = true;
}
