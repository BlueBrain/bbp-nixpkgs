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
    version = "0.1.0-201806";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-MolecularSystems";
        rev = "1e8f23382908bd08fa0f3d5bf75a319261f17b2d";
        sha256 = "1214mv4sq1shmr99ipjwr59df5fnn2bfki6ykh9dbrv5gpqvgymm";
    };

    enableParallelBuilding = true;
}
