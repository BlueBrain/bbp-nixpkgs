{ config
, fetchgit
, pkgconfig
, stdenv
, boost
, freeimage
, cmake
, highfive
, vmmlib
, ospray
, brion
, brayns
}:

stdenv.mkDerivation rec {
    name = "brayns-circuit-explorer-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost freeimage highfive vmmlib ospray brion brayns ];

    src = fetchgit {
        url = "https://github.com/favreau/Brayns-UC-CircuitExplorer";
        rev = "43d9b582a5eb205e72b90c40c34764cfa73f411b";
        sha256 = "1jdyv0nsg9cjvvzr5533x5kr6vpdkfqjyhshwislxpkkc6zk3r0h";
    };

    enableParallelBuilding = true;
}
