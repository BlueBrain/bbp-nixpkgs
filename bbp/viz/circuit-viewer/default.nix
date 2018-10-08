{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, boost
, cmake
, vmmlib
, brayns
, brion
}:

stdenv.mkDerivation rec {
    name = "circuit-viewer-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib brayns brion ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-CircuitViewer";
        rev = "0039a529633232748428b16133bf0cda502d4306";
        sha256 = "0sc47h324kripzrwxy6xz7bwiwpfc770zh2qs7267vpqikhr6sns";
    };

    enableParallelBuilding = true;
}

