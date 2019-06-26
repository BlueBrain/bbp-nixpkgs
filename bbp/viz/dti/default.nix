{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, boost
, cmake
, vmmlib
, brayns
, libpqxx
}:

stdenv.mkDerivation rec {
    name = "diffusion-tensor-imaging-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib brayns libpqxx ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-DTI";
        rev = "e2ee8bf8034223ef265e94ae3636250975c0b123";
        sha256 = "1la5inxrfsldlzrnf5z8arhbhc2nk26gs4yxmla0si5nfi9wn92s";
    };

    enableParallelBuilding = true;
}

