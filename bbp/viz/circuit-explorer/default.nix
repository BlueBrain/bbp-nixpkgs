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
        rev = "95574011b01070aa639bb960772ef4e70bc1c8cb";
        sha256 = "1kxwi024lc8jkdq2dpylnn44lqpvjnxs0978kkj21yv8nsh2hzvr";
    };

	cmakeFlags = [
			"-DISPC_HARDWARE_RANDOMIZER_ENABLED=ON"
		    ];

    enableParallelBuilding = true;
}
