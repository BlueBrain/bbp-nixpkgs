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
        sha256 = "0sa3qji4zbdgl77wdj5w5d7q2mh2f699d85syw1ialpag8pmwjzd";
    };

    # right now no top-level CMakeLists.txt, so build the only module we have now
    preConfigure = ''
        cd deflect
    '';

    outputs = [ "out" ];

    enableParallelBuilding = true;
}
