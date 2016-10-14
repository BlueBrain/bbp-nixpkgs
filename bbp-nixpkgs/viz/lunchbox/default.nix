{ stdenv, boost, fetchgitExternal, cmake, servus, pkgconfig, leveldb, doxygen }:

stdenv.mkDerivation rec {
  name = "lunchbox-1.12.0";
  buildInputs = [ stdenv boost pkgconfig servus cmake leveldb doxygen];

  src = fetchgitExternal{
    url = "https://github.com/Eyescale/Lunchbox.git";
    rev = "3a51571880103e93777ebc339f938137aa33b76c";
    sha256 = "1qpc5q24xxxyglqm1xchrhz7mxyp7sz72p48hal885shm6h84vm5";
  };
  
  enableParallelBuilding = true;

  propagatedBuildInputs = [ servus ];
  
}



