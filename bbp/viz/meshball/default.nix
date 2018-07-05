{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, cmake
, boost
, brion
, cgal
, gmp
, mpfr
}:

stdenv.mkDerivation rec {
    name = "meshball-${version}";
    version = "1.0.0-201807";

    buildInputs = [ stdenv pkgconfig cmake boost brion cgal gmp mpfr ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/MeshBall";
        rev = "4475d7e2b9e459f21e4270ea6d9d5ce91f0a1194";
        sha256 = "0hw8lwkj3a54p7m8m7y2mpknk34wmr976kdka2ssxswqnzfnipdf";
    };
	cmakeFlags = [
	"-DGLM_INSTALL_ENABLE=OFF"
	];

    enableParallelBuilding = true;
}
