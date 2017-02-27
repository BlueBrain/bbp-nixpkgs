{ stdenv, fetchgitPrivate, boost, cmake, clang-analyzer, gsl, mpi, python, cuda, cython}:

stdenv.mkDerivation rec {
  name = "learningengine-${version}";
  version = "0.1";

  buildInputs = [ stdenv boost cmake clang-analyzer gsl mpi python cuda cython];

  src = fetchgitPrivate{
    url = "https://bbpcode.epfl.ch/code/hpc/learning_engine.git";
    rev = "5a036f08053980309108da0eddc91856652f38b0";
    sha256 = "0ycnfy4gjg5blmyj1zh8ymw76kdica7pq5l2dlvrrgb73lhkkrp3";
  };

  enableParallelBuilding = true;

  doCheck = true;

  checkTarget = "test";

}


