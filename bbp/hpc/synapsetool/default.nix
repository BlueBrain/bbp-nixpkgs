{ config
, stdenv
, boost
, cmake
, fetchgitPrivate
, hdf5
, highfive
, pandoc
, python
, useMPI ? false
}:

stdenv.mkDerivation rec {
    name = "synapsetool-${version}";
    version = "0.2.2";

    src = fetchgitPrivate {
        url = "ssh://bbpcode.epfl.ch/hpc/synapse-tool";
        rev = "9d8b8f96e8e19fafe9bbaf8190547ac994dcff73";
        sha256 = "0xkfq688brafsc4k4w40cbwzq5k4s8hb12awxsrzpq9m6cb07k6r";
    };

    cmakeFlags =  [
        "-DSYNAPSE_TOOL_DOCUMENTATION:BOOL=ON"
    ] ++ stdenv.lib.optional useMPI [
        "-DSYNTOOL_WITH_MPI=ON"
    ];

    buildInputs = [
        boost
        hdf5
        highfive
        pandoc
    ];

    nativeBuildInputs = [
        cmake
        python
    ];

    preConfigure = ''
        local v=$(sed -r 's/.*\.([0-9])+$/\1/' <<< ${version})
        sed "s/set(SYNTOOL_VERSION_PATCH.*/set(SYNTOOL_VERSION_PATCH \"$v\")/" -i CMakeLists.txt
    '';
}
