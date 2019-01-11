{ config
, fetchgit
, pkgconfig
, stdenv
, boost
, cmake
, vmmlib
, ospray
, brayns
}:

stdenv.mkDerivation rec {
    name = "brayns-diffusion-tensor-imaging-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib ospray brayns ];

    src = fetchgit {
        url = "https://github.com/favreau/Brayns-UC-DTI.git";
        rev = "a12c54bd3742789ec348dc28e49c7a13f40a38ba";
        sha256 = "1lrpabj0xib7r1kaxz8k6m38gy2ddbq3wka7ymshibm91xrlbk3a";
    };

    enableParallelBuilding = true;
}
