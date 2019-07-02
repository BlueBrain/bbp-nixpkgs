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
        rev = "4fde1bf213f72ffd283844653a15eaf67b690987";
        sha256 = "06zmz29h5d2nfymp37ncmrapvblhsb37dnxbj44r3x8vwl3il4in";
    };
    cmakeFlags = [
      "-DILMBASE_PACKAGE_PREFIX=${ilmbase.dev}"
    ];

    enableParallelBuilding = true;
}
