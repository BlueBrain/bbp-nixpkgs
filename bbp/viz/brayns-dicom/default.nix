{ config
, fetchgit
, pkgconfig
, stdenv
, boost
, cmake
, vmmlib
, dcmtk
, ospray
, brayns
}:

stdenv.mkDerivation rec {
    name = "brayns-dicom-${version}";
    version = "latest";

    buildInputs = [ stdenv pkgconfig cmake dcmtk boost vmmlib ospray brayns ];

    src = fetchgit {
        url = "https://github.com/favreau/Brayns-UC-DICOM.git";
        rev = "8136287e8b61d06c2262605160db7991706de61a";
        sha256 = "1q5ddz51c32zwfvlj765cplvq50p3d5wnk1xqwypvzdjd7gnzws2";
    };

    enableParallelBuilding = true;
}
