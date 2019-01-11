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
    name = "brayns-molecular-systems-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-MolecularSystems";
        rev = "c71821758c430cd13c29eaaa5957a1beb4ee9fc2";
        sha256 = "13iwp0n4cg7qmyrabmdhp24ivpl3phx2q8cyw1z44x3npr2z36kh";
    };

    enableParallelBuilding = true;
}
