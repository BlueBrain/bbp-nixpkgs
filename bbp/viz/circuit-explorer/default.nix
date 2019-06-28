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
        rev = "468846becdc7704e3e5e5b4a46a335dde71e54f6";
        sha256 = "1gk3lx40csmsfxwy8ns0rk3h6r6ifs5208hx5aikm84hf69m8na2";
    };

	cmakeFlags = [
			"-DISPC_HARDWARE_RANDOMIZER_ENABLED=ON"
		    ];

    enableParallelBuilding = true;
}
