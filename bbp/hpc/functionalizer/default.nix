{ stdenv
, config
, fetchgitPrivate
, pkgconfig
, boost
, hpctools
, libxml2
, cmake
, mpiRuntime
, zlib
, python
, pythonPackages
, hdf5
, generateDoc ? true
, asciidoc
, xmlto
, docbook_xsl
, libxslt }:

let
  python-env = python.buildEnv.override {
		extraLibs = [ pythonPackages.h5py ];
  };

in

stdenv.mkDerivation rec {
  name = "functionalizer-${version}";
  version = "3.10.0";

  buildInputs = [ boost hpctools zlib mpiRuntime libxml2 hdf5 ];

  nativeBuildInputs = [
    cmake
    pkgconfig
    python-env
  ] ++ stdenv.lib.optional generateDoc [
    asciidoc
    docbook_xsl
    libxslt
    xmlto
  ];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/building/Functionalizer";
    rev = "f8bea9c66fed7ddc56bf30401d7001c39b4dc7ed";
    sha256 = "1cfylv428vmwpd7b65zzkajb40nmqcljw8xkvlbickxigqja07fs";
  };


  cmakeFlags = [
    "-DUNIT_TESTS=TRUE"
    ''-DLIB_SUFFIX=''
  ] ++ stdenv.lib.optional generateDoc "-DFUNCTIONALIZER_DOCUMENTATION=TRUE";

  enableParallelBuilding = true;

  outputs = [ "out" ] ++ stdenv.lib.optional generateDoc "doc";

  crossAttrs = {
    ## enforce mpiwrapper in cross compilation mode for bgq
    cmakeFlags = cmakeFlags ++ [
      "-DCMAKE_CXX_COMPILER=mpic++"
      "-DCMAKE_C_COMPILER=mpicc"
    ];
  };
}
