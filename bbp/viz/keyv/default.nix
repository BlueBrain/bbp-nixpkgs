{ stdenv, boost, fetchgit, cmake, leveldb, lunchbox, pression }:

stdenv.mkDerivation rec {
  name = "keyv-${version}";
  version = "1.1.0-dev201803";

  buildInputs = [ stdenv boost cmake lunchbox leveldb pression ];

  src = fetchgit {
    url = "https://github.com/BlueBrain/Keyv.git";
    rev = "12d7806a7d82c924a47c48a24abd917ade16bc3e";
    sha256 = "0zn9kk7zhjq7cfrczigsga2y77670ikqg8y3qpgpz0dx5ccij1g7";
  };
  
  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox leveldb pression ];
  
}



