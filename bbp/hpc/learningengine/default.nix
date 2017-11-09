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
                    blas
                    highfive
                    python-env
                    pythonPackages.cython
                    pythonPackages.numpy
                ];

  propagatedBuildInputs = [ pythonPackages.cython pythonPackages.numpy ];

  src = fetchgitPrivate{
    url = config.bbp_git_ssh + "/hpc/learning_engine.git";
    rev = "3f6bd44c7715a1390917cef35cc496c74aa03e24";
    sha256 = "0cqsgpp3w6cffp1dx409pxslqfwrwi10f2v01mgx5j4n7llxcli3";
  };

  enableParallelBuilding = true;

  doCheck = true;

  cmakeFlags =  [
                    "-DLEARNING_ENGINE_SYN2=TRUE"
                    "-DLEARNING_ENGINE_SLURM=FALSE"
		    "-DGIT_VERSION=${src.rev}"
                ] ++ stdenv.lib.optionals ( stdenv ? isICC ) [
		    "-DCMAKE_CXX_FLAGS=-axmic-avx512"
                    "-DOPT_RANDOM=mkl"
                ];

  makeFlags = [
                    "VERBOSE=1"
              ];

  checkPhase = ''
    export PYTHONPATH=${pythonPackages.numpy}/lib/${pythonPackages.python.libPrefix}/site-packages:$PYTHONPATH
    echo "pythonpath $PYTHONPATH"
    ctest -V -E "brunel.*"
  '';

}


