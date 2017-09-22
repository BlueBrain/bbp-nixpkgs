{ stdenv
, cereal
, config
, git
, pandoc? null
, pythonPackages
, fetchgitPrivate
, pkgconfig
, boost
, cmake
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
        pythonPackages.setuptools_scm
        pythonPackages.wheel
      ];
    };
in
  stdenv.mkDerivation rec {
    name = "morpho-tool-${version}";
    version = "0.3-201708";

    src = fetchgitPrivate {
      url = "git@github.com:BlueBrain/morpho-tool.git";
      rev = "3b2682747f4544fdc22742fee1249b3870fb0ce9";
      sha256 = "0sjv2klbsypmv8g083sawsv6yinbv4z53gcv541bgyiahn57j6mr";
      leaveDotGit = true;  # required by setuptools_scm Python module
    };

    meta = {
      homepage = https://github.com/BlueBrain/morpho-tool;
      description = "Perform biological neuron morphologies operations";
      license = stdenv.lib.licenses.gpl2Plus;
    };

    buildInputs = [
      boost
      cereal
      cmake
      hdf5
      git
      pkgconfig
      stdenv
      zlib
    ] ++ stdenv.lib.optional (pandoc != null) pandoc;

    nativeBuildInputs = [ python_test_env ];

    cmakeFlags=[
      "-DUNIT_TESTS=OFF"
      "-DHADOKEN_UNIT_TESTS:BOOL=OFF"
      "-DENABLE_MESHER_CGAL=OFF"
      "-DBUILD_PYTHON_MODULE:BOOL=ON"
      "-DBUILD_PYTHON_DISTRIBUTABLE:BOOL=ON"
      "-DREBUILD_PYTHON_BINDINGS:BOOL=ON"
    ] ++ stdenv.lib.optional (pandoc != null) [
      "-DMORPHO_TOOL_DOCUMENTATION:BOOL=TRUE" ]
    ;

    enableParallelBuilding = true;

    doCheck = true;

    checkPhase = ''
      export LD_LIBRARY_PATH=$PWD/src/io:$PWD/src/morpho:$LD_LIBRARY_PATH;
      export PYTHON_EGG_CACHE="`pwd`/.egg-cache";
      ctest -V
    '';

    outputs = [ "out" ] ++ stdenv.lib.optional (pandoc != null) "doc";

    propagatedBuildInputs = [ highfive ];
  }
