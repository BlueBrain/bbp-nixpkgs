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
        rev = "edaa3fda40e1e1fa4825adfe2b7eefe5552e7585";
        sha256 = "12cjj8j3a2nbkbf69n4zk57m5qwv3wwv9kxkrcmb9zana5s6cc5x";
    };
    cmakeFlags = [
      "-DILMBASE_PACKAGE_PREFIX=${ilmbase.dev}"
    ];

    enableParallelBuilding = true;
}
