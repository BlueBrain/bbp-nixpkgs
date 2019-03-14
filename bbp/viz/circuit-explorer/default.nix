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
, libpqxx
, brayns
}:

stdenv.mkDerivation rec {
    name = "brayns-circuit-explorer-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost freeimage highfive vmmlib ospray libpqxx brion brayns ];

    src = fetchgit {
        url = "https://github.com/favreau/Brayns-UC-CircuitExplorer";
        rev = "48bdf7cbfa2aa9e8afbcacfe649a35877f7a18fa";
        sha256 = "0spnkbzkd514ql3mangwv8vd0k6zp54n0wv55pb8sjcpm0r40a5i";
    };

	cmakeFlags = [
			"-DISPC_HARDWARE_RANDOMIZER_ENABLED=ON"
		    ];

    enableParallelBuilding = true;
}
