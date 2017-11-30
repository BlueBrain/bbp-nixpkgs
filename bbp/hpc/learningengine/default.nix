{ stdenv
, config
, fetchgitPrivate
, zlib
, boost
, cmake
, hdf5
, highfive
, tbb
, blas
, pkgconfig
, pythonPackages
, syntool ? null
}:


let
  python-env = pythonPackages.python.buildEnv.override {
        extraLibs = [ pythonPackages.numpy pythonPackages.matplotlib ];
  };

in



stdenv.mkDerivation rec {
  name = "learningengine-${version}";
  version = "1.1-201711dev";

  buildInputs = [
                    boost
                    zlib
                    cmake
                    tbb
                    pkgconfig
                    syntool
                    hdf5
                    highfive
                    python-env
                    pythonPackages.cython
                    pythonPackages.numpy
                    blas
                ];

  propagatedBuildInputs = [ pythonPackages.cython pythonPackages.numpy ];

  src = fetchgitPrivate{
    url = config.bbp_git_ssh + "/hpc/learning_engine.git";
    rev = "ffe1fc2e69ff6009ea4eb0a024f483aec667b869";
    sha256 = "0alsb2r20y7iz6z22s3k00f742789kdv9ana3rc0hb31nkf9p9bl";
  };

  enableParallelBuilding = true;

  doCheck = true;

  cmakeFlags =  [
                    "-DLEARNING_ENGINE_SYN2=TRUE"
                    "-DLEARNING_ENGINE_SLURM=FALSE"
       		          "-DGIT_VERSION=${src.rev}"
                    "-DOPT_PRECISION=float"
                    "-DLEARNING_ENGINE_BENCHMARK=OFF"
                ] ++ stdenv.lib.optionals ( stdenv ? isICC ) [
                    "-DOPT_RANDOM=mkl"
                ];

  makeFlags = [
                    "VERBOSE=1"
              ];

  checkPhase = ''
    export PYTHONPATH=${pythonPackages.numpy}/lib/${pythonPackages.python.libPrefix}/site-packages:$PYTHONPATH
    echo "pythonpath $PYTHONPATH"
    ctest -V -E "brunelfixedtopo|unit_example_simulations_test|unit_pool_simulations_test|brunel"
  '';

}


