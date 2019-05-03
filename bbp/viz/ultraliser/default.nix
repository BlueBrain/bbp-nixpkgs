{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, cmake
, openexr
, libtiff
, ilmbase
}:

stdenv.mkDerivation rec {
    name = "ultraliser-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake openexr.dev libtiff ilmbase ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Ultraliser";
        rev = "3c6385d9e44e6a1e072b0f5bbf44943aa9094005";
        sha256 = "0zqw7a5rjqfrq0c180hp132pliv6jws15v992frhg6wpkrbmr0mq";
    };
    cmakeFlags = [
      "-DILMBASE_PACKAGE_PREFIX=${ilmbase.dev}"
    ];

    enableParallelBuilding = true;
}
