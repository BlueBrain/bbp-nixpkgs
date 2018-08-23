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
        rev = "2b6624948c7288c42458cdcd78389ad3167db630";
        sha256 = "15qnbghf29b847mh9wvd6lh7lm6cak4jn21binygpncbwikz9qsq";
    };

    enableParallelBuilding = true;
}
