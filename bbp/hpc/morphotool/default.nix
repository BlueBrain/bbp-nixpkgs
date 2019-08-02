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
        pythonPackages.cython-0-27
        pythonPackages.numpy
      ];

    };
in
  stdenv.mkDerivation rec {
    name = "morpho-tool-${version}";
    version = "0.3-201711";

    src = fetchgitPrivate {
      url = "git@github.com:BlueBrain/morpho-tool.git";
      rev = "8864aa2c36d39b118f5baf698b6da9e3bb65fb65";
      sha256 = "14n0ip5kgqxpjf4d057q9jcxfd7pcj13sqqxp6wldq8f0a4q2x0s";
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

    preConfigure = ''
	# add setuptools to the path
	# and fix the date issue with setuptools (https://github.com/NixOS/nixpkgs/issues/270 )
	export PYTHONPATH=${pythonPackages.bootstrapped-pip}/lib/${pythonPackages.python.libPrefix}/site-packages:$PYTHONPATH
	find python/ -type f | xargs touch
   '';

    cmakeFlags=[
      "-DHADOKEN_UNIT_TESTS:BOOL=OFF"
      "-DBUILD_PYTHON_MODULE:BOOL=ON"
      "-DREBUILD_PYTHON_BINDINGS:BOOL=ON"
    ] ++ stdenv.lib.optional (pandoc != null) [
      "-DMORPHO_TOOL_DOCUMENTATION:BOOL=TRUE" ]
    ;

    enableParallelBuilding = true;

    doCheck = true;

    checkPhase = ''
      export LD_LIBRARY_PATH=$PWD/src/io:$PWD/src/morpho:${hdf5}/lib:$LD_LIBRARY_PATH;
      export PYTHON_EGG_CACHE="`pwd`/.egg-cache";
      ctest -V
    '';

    outputs = [ "out" ] ++ stdenv.lib.optional (pandoc != null) "doc";

    propagatedBuildInputs = [ highfive ];

    passthru = {
	pythonEnv = python_test_env;
    };
 
    meta = {
      homepage = https://github.com/BlueBrain/morpho-tool;
      description = "Perform biological neuron morphologies operations";
      license = stdenv.lib.licenses.gpl2Plus;
      maintainers = [
        config.maintainers.adevress
      ];
    };


 }
