{ stdenv
, fetchgitPrivate
, boost
, cmake
, gsl
, mpi
, tbb
, pkgconfig
, python
, cython}:

stdenv.mkDerivation rec {
  name = "learningengine-${version}";
  version = "1.0-201704";

  buildInputs = [ stdenv boost cmake gsl mpi python cython tbb pkgconfig ];

  src = fetchgitPrivate{
    url = "ssh://bbpcode.epfl.ch/hpc/learning_engine.git";
    rev = "fea49f4b5f817275b9a56785e641a2f13e89a088";
    sha256 = "1yxbms76n9gzz9y45zmjykkdv9z64mpj0gf4h2hl7klymvwz5g3s";
  };

  enableParallelBuilding = true;

  doCheck = true;

  checkTarget = "test";

}


