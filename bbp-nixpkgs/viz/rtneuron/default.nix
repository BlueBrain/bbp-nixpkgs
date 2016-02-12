{ stdenv, 
fetchgitPrivate, 
boost, 
cpp-netlib, 
pkgconfig, 
cmake, 
cmake-external, 
lunchbox, 
servus,
brion, 
python }:

stdenv.mkDerivation rec {
  name = "rtneuron-2.10.0";
  buildInputs = [ stdenv pkgconfig boost cpp-netlib cmake-external cmake lunchbox servus brion python];

  src = fetchgitPrivate{
    url = "ssh://bbpcode.epfl.ch/viz/RTNeuron";
    rev = "f29be0399345aaf191074893c01ec51fa28f3f7b";
    sha256 = "11j1l1rdq22d4iyzlxsrhhc2462nfcxms0qdyra61r1vhk6nb251";
    deepClone = true;
  };
  
  enableParallelBuilding = true;
  
}



