{ config
, fetchgit
, pkgconfig
, stdenv
, boost
, cmake
, hdf5-cpp
, highfive
, vmmlib
, ospray
, brayns
}:

stdenv.mkDerivation rec {
    name = "brayns-graphs-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost hdf5-cpp highfive vmmlib ospray brayns ];

    src = fetchgit {
        url = "https://github.com/favreau/Brayns-UC-Graphs.git";
        rev = "945d810c34b89891d548fdd2bcb5829113fd803d";
        sha256 = "081d0qddjm9naiyz6r1hxkq17jljmbvb81ihlvam2709fzkyj5ma";
    };

    enableParallelBuilding = true;
}
