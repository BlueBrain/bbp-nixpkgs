{ blas
, boost
, cmake
, config
, fetchgitPrivate
, hdf5
, highfive
, pkgconfig
, pythonPackages
, stdenv
, syntool ? null
, tbb
, zlib
}:

let
  python-env = pythonPackages.python.buildEnv.override {
    extraLibs = with pythonPackages; [
      numpy
      matplotlib
      sphinx
    ];
  };

in

stdenv.mkDerivation rec {
  name = "learningengine-${version}";
  version = "1.1-201712dev";
  src = fetchgitPrivate{
    url = config.bbp_git_ssh + "/hpc/learning_engine.git";
    rev = "3de9a7afb6f3f87f069b6511344934d27dc472ea";
    sha256 = "1vxq2w0jhx3qg89rvhhxbh7rllp5g8cyzsbxgrbzc9kc1jx4alxv";
  };


  meta = {
    description = "Point neuron simulator";
    longDescription = ''
      The LearningEngine is a point neuron simulator.
      It supports the Adex and GIF model for neurons and the
      Tsodyks-Markram model for synapses.
      A Python interface allows easy access of all neuron and synapse
      parameters and states.
    '';
    homepage = "https://bbpcode.epfl.ch/code/#/admin/projects/hpc/learning_engine";
    platforms = stdenv.lib.platforms.unix;
    repository = "ssh://bbpcode.epfl.ch/hpc/learning_engine";
    license = {
      fullName = "Copyright 2017 Blue Brain Project";
    };
    maintainers = [
      config.maintainers.till
      config.maintainers.timocafe
    ];
  };

  preConfigure = ''
    export CXXFLAGS="-fopenmp"
    export CPPFLAGS="$CXXFLAGS"
  '';

  buildInputs = [
    blas
    boost
    cmake
    hdf5
    highfive
    pkgconfig
    python-env
    pythonPackages.cython
    pythonPackages.numpy
    syntool
#    tbb
    zlib
  ];
  propagatedBuildInputs = with pythonPackages; [
    cython
    numpy
  ];

  cmakeFlags =  [
    "-DGIT_VERSION=${src.rev}"
    "-DLEARNING_ENGINE_BENCHMARK=OFF"
    "-DLEARNING_ENGINE_SLURM=FALSE"
    "-DLEARNING_ENGINE_SPHINX:BOOL=ON"
    "-DLEARNING_ENGINE_SYN2=TRUE"
    "-DOPT_PRECISION=float"
    "-DOPT_THREAD=omp"
  ] ++ stdenv.lib.optionals (stdenv ? isICC) [
    "-DOPT_RANDOM=mkl"
  ];

  makeFlags = [
    "VERBOSE=1"
  ];
  enableParallelBuilding = true;

  doCheck = true;
  excludedTests = [
    "brunel"
    "brunelfixedtopo"
    "unit_example_simulations_test"
    "unit_pool_simulations_test"
  ];
  checkPhase = ''
    export PYTHONPATH=${pythonPackages.numpy}/lib/${pythonPackages.python.libPrefix}/site-packages:$PYTHONPATH
    export LD_LIBRARY_PATH="''${PWD}/learningengine:${hdf5}/lib:''${LD_LIBRARY_PATH}"
    echo "pythonpath $PYTHONPATH"
    ctest -V -E "${builtins.concatStringsSep "|" excludedTests}"
  '';

  outputs = [ "out" "doc" ];
}
