{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, boost
, cmake
, highfive
, vmmlib
, brayns
}:

stdenv.mkDerivation rec {
    name = "membraneless-organelles-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost highfive vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-MembranelessOrganelles";
        rev = "9f0c6c36c6c74e5e3fffa2cb28b43bc90e96f0d0";
        sha256 = "1678ckhzydjpj379j2hqp6df45vcxczij42nxdrw2csp39lna552";
    };

    enableParallelBuilding = true;
}
