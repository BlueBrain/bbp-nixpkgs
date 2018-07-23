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
    version = "0.2";


    src = fetchgitPrivate {
        url = "ssh://bbpcode.epfl.ch/hpc/synapse-tool";
        rev = "a384860cd3d3382017230a58f41601f72e3cc2a3";
        sha256 = "01giysxyjnclj2r5i39ysfvkx8ljnbqhlsq2bwa3n1cs3m7iy8fd";
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

}
