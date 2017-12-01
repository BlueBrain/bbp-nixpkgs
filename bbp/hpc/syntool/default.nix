{ config
, stdenv
, boost
, cmake
, fetchgitPrivate
, hdf5
, highfive
, pandoc
, python
}:

stdenv.mkDerivation rec {
  name = "syn-tool-${version}";
  version = "0.1-dev201709";
  src = fetchgitPrivate {
      url = "ssh://bbpcode.epfl.ch/hpc/synapse-tool";
      rev = "d658c7346e2a3ef7082a6ff643078099460d7aa4";
      sha256 = "15j6jclhmy5ymjp6w42n3gbs8b9b2hx5kk95sryr5ypcpmyy1mpy";
  };
  meta = {
    description = "Toolkit to read syngit logapse/neuron connectivity file formats";
    longDescription = ''
      SYN-TOOL provides a C++ and a python API to read / write neuron
      connectivity informations. It manages the following file format :
      - SYN2: HDF5 based Open File format Specification
      - NRN (Legacy Blue Brain Project synapse file format)
      SYN-TOOL is designed to support large connecitivy data with
      billions of connections.
    '';
    homepage = "https://bbpcode.epfl.ch/code/#/admin/projects/hpc/synapse-tool";
    platforms = stdenv.lib.platforms.unix;
    repository = "ssh://bbpcode.epfl.ch/hpc/synapse-tool";
    license = {
      fullName = "Copyright 2017 Blue Brain Project";
    };
    maintainers = [
      config.maintainers.adevress
      config.maintainers.ferdonline
    ];
  };
  cmakeFlags =  [
    "-DSYNAPSE_TOOL_DOCUMENTATION:BOOL=ON"
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

  outputs = [ "out" "doc" ];
}
