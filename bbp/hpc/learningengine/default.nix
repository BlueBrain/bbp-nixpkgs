{ stdenv
, config
, fetchgitPrivate
, zlib
, boost
, cmake
, hdf5
, highfive
, gsl
, tbb
, pkgconfig
, pythonPackages
, mpi ? null
, syntool ? null
}:


let
  python-env = pythonPackages.python.buildEnv.override {
        extraLibs = [ pythonPackages.numpy ];
  };

in



stdenv.mkDerivation rec {
  name = "learningengine-${version}";
  version = "1.0-201708";

  buildInputs = [ 
                    boost 
                    zlib
                    cmake
                    tbb
                    pkgconfig
                    gsl
                    mpi
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
    rev = "aaec1af71d42092002faba0ad0b01977204c3cc5";
    sha256 = "1ms7ziizj68y3vp99l71g97gx4v06al7yz0dy99xc2xi7ddpg9y8";
  };

  enableParallelBuilding = true;

  patches = [ ./python-path.patch ];

  doCheck = true;

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


