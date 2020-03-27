{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, cmake
, openscenegraph
, boost
, opengl
}:

stdenv.mkDerivation rec {
    name = "regiodesics";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost openscenegraph opengl ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Regiodesics";
        rev = "27263dc541b02494a0693f7af79cc36614cd548e";
        sha256 = "0x8d21a5ksrgi7k9zyix24lq6lrpnrxmsjhkjpl5lmsaxzawivk9";
    };

    enableParallelBuilding = true;
}
