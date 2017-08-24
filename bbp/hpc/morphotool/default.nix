{ stdenv
, cereal
, config
, pythonPackages
, fetchgitPrivate
, pkgconfig
, boost
, cmake38
, zlib
, hdf5
, highfive
 }:

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

    buildInputs = [
      cereal
      stdenv
      pkgconfig
      boost
      zlib
      cmake38
      hdf5
    ];
    nativeBuildInputs = [ python_test_env ];

    src = fetchgitPrivate {
      url = "git@github.com:BlueBrain/morpho-tool.git";
      rev = "f9d140bcf156e4a5012526756a588d77ab619fbe";
      sha256 = "06xixqbgiqb044iv38gfiaysv6r2h98n17af3j72aisf63k9vqb9";
    };

    cmakeFlags=[
      "-DUNIT_TESTS=OFF"
      "-DHADOKEN_UNIT_TESTS:BOOL=OFF"
      "-DENABLE_MESHER_CGAL=OFF"
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
