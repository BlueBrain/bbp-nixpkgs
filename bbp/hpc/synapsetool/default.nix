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
    version = "0.3.1";

    src = fetchgitPrivate {
        url = "ssh://bbpcode.epfl.ch/hpc/synapse-tool";
        rev = "b6f7120225135b07f1e8ca22a1cbf5be963c80a1";
        sha256 = "1jp8acdpa92v9c6p57iazn0f4ns1745jfa9v6pyfk1gpndjafrpv";
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
