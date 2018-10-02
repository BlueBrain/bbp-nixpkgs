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
    version = "0.2.5";

    src = fetchgitPrivate {
        url = "ssh://bbpcode.epfl.ch/hpc/synapse-tool";
        rev = "27e90878171588f49ab1b13e15e94c3e2e9a5fed";
        sha256 = "0fc19mlj0g2f1jprw8c1hx6539pbyv7c6dymxw0jsw4aq06mb29n";
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
