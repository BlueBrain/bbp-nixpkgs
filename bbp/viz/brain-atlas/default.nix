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
    name = "brain-atlas-${version}";
    version = "0.1.0-201806";

    buildInputs = [ stdenv pkgconfig cmake boost highfive vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-BrainAtlas";
        rev = "c0e9516ce83833be2defadd2764e5677e9cd5ec7";
        sha256 = "1802hwnsk5bb79i4yyih6xgq4v3y9inxv2q61wk92y78niqi0yjv";
    };

    enableParallelBuilding = true;
}
