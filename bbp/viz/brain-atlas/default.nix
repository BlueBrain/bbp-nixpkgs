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
        rev = "bbb61b3d625461168da4f96155f2d67634401eb4";
        sha256 = "1w4h1pdb9y1dv299g7qvy8yzfydwhfa77siwlawkivs399ax9qnx";
    };

    enableParallelBuilding = true;
}
