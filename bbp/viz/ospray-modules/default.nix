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
        sha256 = "1hzsdx05m4bl10r2an1almgyv4iaa542a1r9l6im68an5zpkjkf5";
    };


    enableParallelBuilding = true;
}
