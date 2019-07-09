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
        rev = "1c6a70e634d07530c1f6299d38064e582cea71ac";
        sha256 = "0dinqryih8837pv84bwfxl77pjlw1lyw4hzj2w8q8hsdrgz0mzwd";
    };

	cmakeFlags = [
			"-DISPC_HARDWARE_RANDOMIZER_ENABLED=ON"
		    ];

    enableParallelBuilding = true;
}
