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
        rev = "22baaaf308873b7df0a014c667f3d34e3f9407a1";
        sha256 = "1pbp9k7620yir1sdjzjchcbcissn39yi4wvrwxhvimcs8pgcipgw";
    };
	cmakeFlags = [
	"-DGLM_INSTALL_ENABLE=OFF"
	];

    enableParallelBuilding = true;
}
