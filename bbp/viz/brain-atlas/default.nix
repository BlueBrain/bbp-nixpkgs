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
        rev = "b72f4b0e3b527df0c1d6a77f9f4f283a324ee16d";
        sha256 = "0dwv8rkvmz333z2z0hlglw0aqi7vy1j97fv1yzbp3xsz3kn6svnw";
    };

    enableParallelBuilding = true;
}
