{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, cmake
, boost
, brion
, glm
, ispc
}:

stdenv.mkDerivation rec {
    name = "emsim-${version}";
    version = "1.0.0-201806";

    buildInputs = [ stdenv pkgconfig cmake boost brion glm ispc ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/EMSim";
        rev = "6023b1fe6f51ef77e47995e4a7685a109c1de6a6";
        sha256 = "11frh2m0021px9w188rs2468a08xx66r45kym2ma0jfmqz2zzf2b";
    };

    enableParallelBuilding = true;
}
