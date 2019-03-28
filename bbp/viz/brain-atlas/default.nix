{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, boost
, cmake
, brayns
}:

stdenv.mkDerivation rec {
    name = "brain-atlas-${version}";
    version = "0.1.0-201806";

    buildInputs = [ stdenv pkgconfig cmake boost brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-BrainAtlas";
        rev = "a9c1d353e69927ffc1dafccc1a8d75b4b6024118";
        sha256 = "1cfj16dqa7shpc4mq8n12ccg6y3yhh4327cyjai17w8ls4hz2iba";
    };

    enableParallelBuilding = true;
}
