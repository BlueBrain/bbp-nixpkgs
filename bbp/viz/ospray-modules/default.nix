{ stdenv
, fetchgitPrivate
, doxygen
, cmake
, deflect
, ospray
}:


stdenv.mkDerivation rec {
        name = "ospray-modules-${version}";
        version = "1.0";

        buildInputs = [ deflect ospray ];

        nativeBuildInputs = [ doxygen cmake ];

        src = fetchgitPrivate {
        url = "git@github.com:BlueBrain/ospray-modules.git";
        rev = "da6730d4fe4b51b0f571865c20f6e7e158396f49";
        sha256 = "0cq0fl1gp1pm1sgwzkd1lb7ijr020q4jwg5q3ynza7zic2f7mw9k";
    };

    outputs = [ "out" ];

    enableParallelBuilding = true;
}
