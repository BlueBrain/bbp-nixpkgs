{ stdenv, boost, fetchgitExternal, cmake, servus, pkgconfig, leveldb, doxygen }:

stdenv.mkDerivation rec {
  name = "lunchbox-1.12.0";
  buildInputs = [ stdenv boost pkgconfig servus cmake leveldb doxygen];

  src = fetchgitExternal{
    url = "https://github.com/Eyescale/Lunchbox.git";
    rev = "921dc9b477ae0f5e99d59d6023ebaf6deb68abd3";
    sha256 = "05xa481fk35d49fkl7fplvb78ghqvdwigfp8qln2hqlwqfy035gl";
  };
  
  enableParallelBuilding = true;

  propagatedBuildInputs = [ servus ];
  
}



