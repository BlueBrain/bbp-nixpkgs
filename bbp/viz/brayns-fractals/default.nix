{ config
, fetchgit
, pkgconfig
, stdenv
, boost
, cmake
, vmmlib
, ospray
, brayns
}:

stdenv.mkDerivation rec {
    name = "brayns-fractals-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib ospray brayns ];

    src = fetchgit {
        url = "https://github.com/favreau/Brayns-UC-Fractals.git";
        rev = "ec72e4b7e5337276f96d3e4d894226dc5c784a8e";
        sha256 = "0adr5d4ch32jnafgia95717gcw1jq701w5lg0dhb0zc36rag6w60";
    };

    enableParallelBuilding = true;
}
