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
        rev = "20f84e21cf54e4d38b0e50902f5d040989062bb1";
        sha256 = "1bw6qa3zxxwg5vn5b3j1djsii09h8ayd61q3riyv4qc4df9mrlci";
    };

    enableParallelBuilding = true;
}
