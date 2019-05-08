{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, boost
, freeimage
, cmake
, highfive
, ospray
, brion
, libpqxx
, brayns
}:

stdenv.mkDerivation rec {
    name = "brayns-circuit-explorer-${version}";
    version = "0.1.0";

    buildInputs = [ stdenv pkgconfig cmake boost freeimage highfive ospray libpqxx brion brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-CircuitExplorer";
        rev = "9d9723aeff16bd6c4327adabb1710af66735b879";
        sha256 = "0281q3sr0ad59csxfrrvdl2cy6c6jf4ab0j2ka0yk1ygmg083rl4";
    };

	cmakeFlags = [
			"-DISPC_HARDWARE_RANDOMIZER_ENABLED=ON"
		    ];

    enableParallelBuilding = true;
}
