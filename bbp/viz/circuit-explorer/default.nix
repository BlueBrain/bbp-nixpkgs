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
        rev = "4cb970f4a84638d165e83c8de57fadaafb80428a";
        sha256 = "0pdfbb96cv9jxwidq51rd7ak4n357bajkcx7s8syp842hcflhx4b";
    };

	cmakeFlags = [
			"-DISPC_HARDWARE_RANDOMIZER_ENABLED=ON"
		    ];

    enableParallelBuilding = true;
}
