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
  version = "1.0-201710dev";

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
    rev = "3f9e41c87c8d276439bbee7d63c86d666b3c831b";
    sha256 = "1wxkh50kk1rhwvhf903wgviddvj0xbr952h379qx4hafyx2zb2xp";
  };

  enableParallelBuilding = true;

  doCheck = true;

  cmakeFlags =  [
                    "-DLEARNING_ENGINE_SYN2=TRUE"
                    "-DLEARNING_ENGINE_SLURM=FALSE"
        		    "-DGIT_VERSION=${src.rev}"
                    "-DOPT_PRECISION=double"
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
    ctest -V -E "brunelfixedtopo|unit_example_simulations_test|unit_pool_simulations_test"
  '';

}


