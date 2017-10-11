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
        rev = "558d7f4862b2aef653bdb34c33bb246c84730ce6";
        sha256 = "1dfjy5385czh34mp6b0jydxgyqwrbb1qzf94q6vbhxkv8aw07xqj";
    };

    # right now no top-level CMakeLists.txt, so build the only module we have now
    preConfigure = ''
        cd deflect
    '';

    outputs = [ "out" ];

    enableParallelBuilding = true;
}
