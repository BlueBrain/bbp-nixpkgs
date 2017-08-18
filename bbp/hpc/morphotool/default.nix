{ stdenv
, config
, pythonPackages
, fetchgitPrivate
, pkgconfig
, boost
, cmake38
, zlib
, hdf5
, highfive
, cgal
, gmp
, mpfr }:

let
    # create a python environment with numpy for numpy bindings tests
    python_test_env = pythonPackages.python.buildEnv.override {
      extraLibs = [
        pythonPackages.cython
        pythonPackages.numpy
        pythonPackages.setuptools30
        pythonPackages.wheel
      ];
    };
in
  stdenv.mkDerivation rec {
    name = "morpho-tool-${version}";
    version = "0.2-201704";

    buildInputs = [ stdenv pkgconfig boost zlib cmake38 hdf5 cgal gmp mpfr ];
    nativeBuildInputs = [ python_test_env ];

    src = fetchgitPrivate {
      url = config.bbp_git_ssh + "/hpc/morpho-tool";
      rev = "047cf3c5a47ac486b7e660e0630b50203c9ec6fc";
      sha256 = "0w2gyanfsidfysfz06djssflha9agzniagynqcpfch6jxglibn92";
    };

    cmakeFlags=[
      "-DUNIT_TESTS=OFF"
      "-DENABLE_MESHER_CGAL=ON"
      "-DBUILD_PYTHON_MODULE:BOOL=ON"
      "-DBUILD_PYTHON_DISTRIBUTABLE:BOOL=ON"
      "-DREBUILD_PYTHON_BINDINGS:BOOL=ON"
    ];

    enableParallelBuilding = true;

    doCheck = true;

    checkPhase = ''
      export LD_LIBRARY_PATH=$PWD/src/io:$PWD/src/morpho:$LD_LIBRARY_PATH;
      ctest -V
    '';

    propagatedBuildInputs = [ highfive ];
  }
