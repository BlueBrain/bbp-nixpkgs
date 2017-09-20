{ stdenv, boost, fetchgit, cmake, leveldb, lunchbox, pression }:

stdenv.mkDerivation rec {
  name = "keyv-${version}";
  version = "1.1.0-dev201708";

  buildInputs = [ stdenv boost cmake lunchbox leveldb pression ];

  src = fetchgit {
    url = "https://github.com/BlueBrain/Keyv.git";
    rev = "7951173ffb9602392a353c2c8bb6a8ea7bc2f831";
    sha256 = "0zn9kk7zhjq7cfrczigsga2y77670ikqg8y3qpgpz0dx5ccij1g7";
  };
  
  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox leveldb pression ];
  
}



