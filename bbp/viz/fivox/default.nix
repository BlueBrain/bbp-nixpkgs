{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, cmake
, boost
, brion
, ispc
, lunchbox
, itk
}:

stdenv.mkDerivation rec {
    name = "fivox-${version}";
    version = "0.7.0";

    buildInputs = [ stdenv pkgconfig cmake boost brion ispc lunchbox itk ];

    src = fetchgitPrivate {
        url = "https://github.com/BlueBrain/Fivox.git";
        rev = "23347a81aff406db47727e7c16123ccbefa08388";
        sha256 = "1iwfqd90zzgnyhns3pnbbpv561rxdpg2q9shiinj64j7qx9p36yi";
    };

    cmakeFlags = [ "-DCOMMON_DISABLE_WERROR=TRUE"];
    enableParallelBuilding = true;
}
