{ stdenv
, config
, fetchgitPrivate
, zlib
, boost
, cmake
, hdf5
, highfive
, tbb
, pkgconfig
, pythonPackages
, syntool ? null
}:


let
  python-env = pythonPackages.python.buildEnv.override {
        extraLibs = [ pythonPackages.numpy ];
  };

in



stdenv.mkDerivation rec {
  name = "learningengine-${version}";
  version = "1.0-201710";

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
                ];

  propagatedBuildInputs = [ pythonPackages.cython pythonPackages.numpy ];

  src = fetchgitPrivate{
    url = config.bbp_git_ssh + "/hpc/learning_engine.git";
    rev = "11f6e337fb6afbbb46d577bbc62e8c4e1146be4d";
    sha256 = "0sv7hz881z1bmjh59vb3v85nj5hjmlmf8dn04izwb0lik51rgdkw";
  };

  enableParallelBuilding = true;

  doCheck = true;

  # if support MKL the following option should be added next dictionnary "-DOPT_RANDOM=mkl"
  cmakeFlags =  [
                    "-DLEARNING_ENGINE_SYN2=TRUE"
                    "-DLEARNING_ENGINE_SLURM=FALSE"
                ];

  checkPhase = ''
    export PYTHONPATH=${pythonPackages.numpy}/lib/${pythonPackages.python.libPrefix}/site-packages:$PYTHONPATH
    echo "pythonpath $PYTHONPATH"
    ctest -V -E "brunel.*"
  '';

}


