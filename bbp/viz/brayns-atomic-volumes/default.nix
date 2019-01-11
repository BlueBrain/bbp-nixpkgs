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
    name = "brains-atomic-volumes-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib ospray brayns ];

    src = fetchgit {
        url = "https://github.com/favreau/Brayns-UC-AtomicVolumes.git";
        rev = "a92af755e5b2604bf6e5295452862651e30bd0ab";
        sha256 = "09lfvh4y9d5qmwjckwis842j5mq5j9aif35vnrycm38m2icflph3";
    };

    enableParallelBuilding = true;
}
