{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, cmake
, boost
, vmmlib
, brayns
}:

stdenv.mkDerivation rec {
    name = "molecular-systems-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib brayns ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-MolecularSystems";
        rev = "d7121cb51a498e73e1742e91fb9719ad2a74a303";
        sha256 = "01208c6iyssn23razddxq8qkfhcanl7xmv6iya3bcqgjcagfzgdk";
    };

    enableParallelBuilding = true;
}
