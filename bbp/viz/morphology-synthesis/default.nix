{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, cmake
, boost
, brayns
}:

stdenv.mkDerivation rec {
    name = "morphology-synthesis-${version}";
    version = "0.1.0-201806";

    buildInputs = [ stdenv pkgconfig cmake boost brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-MorphologySynthesis";
        rev = "414c10401a8ad1058cb41b8abd168a5f084432f8";
        sha256 = "0iclz24ib7lxix9vv311z2qa6ii2hr16ahmzriws8g2sq8zlcc91";
    };

    enableParallelBuilding = true;
}
