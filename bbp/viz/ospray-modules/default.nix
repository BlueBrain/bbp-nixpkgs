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
        rev = "35be398e8e400bf4523d64512daefafb658e8115";
        sha256 = "0bbqb55vvd5fjbfaqri4jywg6nvpmaybqp33428rc5vns1hrqpva";
    };

    # right now no top-level CMakeLists.txt, so build the only module we have now
    preConfigure = ''
        cd deflect
    '';

    outputs = [ "out" ];

    enableParallelBuilding = true;
}
