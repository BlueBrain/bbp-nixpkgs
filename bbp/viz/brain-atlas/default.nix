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
        rev = "10b50093a84866df18549e5c2b467c19fc36aa72";
        sha256 = "0j8ya17ha7qydjs3cxsb58ksnhdv3hp9rcpv4bk2x4lqa96w5cr0";
    };

    enableParallelBuilding = true;
}
