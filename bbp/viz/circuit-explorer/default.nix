{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, boost
, freeimage
, cmake
, highfive
, vmmlib
, ospray
, brion
, libpqxx
, brayns
}:

stdenv.mkDerivation rec {
    name = "brayns-circuit-explorer-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost freeimage highfive vmmlib ospray libpqxx brion brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-CircuitExplorer";
        rev = "7921cc5c992ec3218d4e98f55ad6fcfd2a25fc23";
        sha256 = "1lwfmwz3s61j76v9c8hw0r22ggg5k7jzbmz0d3m69l7nfjb9v9jd";
    };

	cmakeFlags = [
			"-DISPC_HARDWARE_RANDOMIZER_ENABLED=ON"
		    ];

    enableParallelBuilding = true;
}
