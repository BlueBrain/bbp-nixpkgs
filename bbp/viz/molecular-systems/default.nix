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
        rev = "66448477d13b31705ea26be367627fef4b2e1193";
        sha256 = "1xr9smm5lkd8asbiacrr9hzbkrmv180pbs46ya9x2f0zr4s9nb2b";
    };

    enableParallelBuilding = true;
}
