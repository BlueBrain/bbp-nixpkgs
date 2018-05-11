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
    version = "0.1-dev201805";


    src = fetchgitPrivate {
        url = "ssh://bbpcode.epfl.ch/hpc/synapse-tool";
        rev = "6ef3eb401f3fca5badfaa77d40ae6728970c6cba";
        sha256 = "06iwz15f67nb01y904xwy9j52qk8bhflclkyi4b488k4qh91cakf";
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

}
