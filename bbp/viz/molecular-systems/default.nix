{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, cmake
, boost
, vmmlib
, brayns
}:

stdenv.mkDerivation rec {
    name = "molecular-systems-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-MolecularSystems";
        rev = "27cbc5b10d91de38bd3dffd0a5f574e9db258c09";
        sha256 = "1dg4s8sir77592pnfdm9w7ck62fnaddp2zk55j82pp6qk1bn6nri";
    };

    enableParallelBuilding = true;
}
