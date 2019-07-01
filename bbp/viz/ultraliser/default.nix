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
        rev = "0ed3cdd9179e9d8aad8b1ea5ab05fcb6e4392ed1";
        sha256 = "0n787zqfg501nik3zql4l50nvlcc6px8iw30hdciafv2n5zvdnzg";
    };
    cmakeFlags = [
      "-DILMBASE_PACKAGE_PREFIX=${ilmbase.dev}"
    ];

    enableParallelBuilding = true;
}
