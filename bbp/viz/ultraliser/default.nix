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
        rev = "3059ab992b3f61f7b7fbcc4d2fd6a9da41d653f9";
        sha256 = "01b953qwdkswsjn7ds1cim6w9xghka2afqwxvb7p2dvzk15a6fpv";
    };
    cmakeFlags = [
      "-DILMBASE_PACKAGE_PREFIX=${ilmbase.dev}"
    ];

    enableParallelBuilding = true;
}
