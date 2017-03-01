{ stdenv, boost, fetchgitExternal, cmake, leveldb, lunchbox, pression }:

stdenv.mkDerivation rec {
  name = "keyv-${version}";
  version = "1.0.0";

  buildInputs = [ stdenv boost cmake lunchbox leveldb pression ];

  src = fetchgitExternal{
    url = "https://github.com/BlueBrain/Keyv.git";
    rev = "3fe99276b2eaa2d1f754e77e36462b1435805c4c";
    sha256 = "0fyhkvhrwmq24c9rqxzf1frslvvhhvzqymxpkr9n1p8shwy5v7y5";
  };
  
  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox leveldb pression ];
  
}



