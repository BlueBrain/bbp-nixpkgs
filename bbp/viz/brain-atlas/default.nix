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
        rev = "ce3afec8603ff5284fb121c7f056064e30679fb3";
        sha256 = "06sp31fqdx967c7177mwg3h0rd7cmndj2qv28anmxjn89k9aip6j";
    };

    enableParallelBuilding = true;
}
