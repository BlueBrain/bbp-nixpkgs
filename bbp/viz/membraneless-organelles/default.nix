{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, boost
, cmake
, brayns
}:

stdenv.mkDerivation rec {
    name = "membraneless-organelles-${version}";
    version = "0.1.0-201806";

    buildInputs = [ stdenv pkgconfig cmake boost brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-MembranelessOrganelles";
        rev = "f1c51af340b19afb410973e9193e1866c7376069";
        sha256 = "128h64g8zk23xas7rmvsvzzd7ryn4n2dz5k96prwx3kr9bsi6lzg";
    };

    enableParallelBuilding = true;
}
