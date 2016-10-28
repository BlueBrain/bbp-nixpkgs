{ stdenv, fetchgitExternal, boost, cmake, clang-format}:

stdenv.mkDerivation rec {
  name = "cyme-${version}";
  version = "0.1";

  buildInputs = [ stdenv boost cmake clang-format];

  src = fetchgitExternal {
    url = "https://bbpcode.epfl.ch/code/a/hpc/learning_engine.git";
    rev = "g8c3708ae10a85706ac487400da75e8e03c0b5b9";
    sha256 = "0ycnfy4gjg5blmyj1zh8ymw76kdica7pq5l2dlvrrgb73lhkkrp3";
  };

  enableParallelBuilding = true;

  doCheck = true;

  checkTarget = "test";

}


