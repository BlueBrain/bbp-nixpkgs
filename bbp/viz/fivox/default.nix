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
        rev = "7c4fc75eaf0ed0cf0183894c753fd9f2b6a9db36";
        sha256 = "19zpvdzqa1viy4wvmncl9gh16w1yqyhlwjr60s0jp7m5ah9s86jr";
    };

    cmakeFlags = [ "-DCOMMON_DISABLE_WERROR=TRUE"];
    enableParallelBuilding = true;
}
