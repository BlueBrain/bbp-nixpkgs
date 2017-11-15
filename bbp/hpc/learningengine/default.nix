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
        extraLibs = [ pythonPackages.numpy ];
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
                ];

  propagatedBuildInputs = [ pythonPackages.cython pythonPackages.numpy ];

  src = fetchgitPrivate{
    url = config.bbp_git_ssh + "/hpc/learning_engine.git";
    rev = "c8760c3f85d9d8f3b654237fa538c38e450cfc4e";
    sha256 = "1427jjqyjn4875116yzgmx5vxw46nm37gaiasjg0dsani7x9s6wr";
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
                    "-DOPT_RANDOM=standard"
                ];

  makeFlags = [
                    "VERBOSE=1"
              ];

  checkPhase = ''
    export PYTHONPATH=${pythonPackages.numpy}/lib/${pythonPackages.python.libPrefix}/site-packages:$PYTHONPATH
    echo "pythonpath $PYTHONPATH"
    ctest -V -E brunelfixedtopo
  '';

}


