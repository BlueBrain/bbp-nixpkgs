{ stdenv, fetchgit, cmake,  boost, pkgconfig, doxygen, avahi ? null }:

stdenv.mkDerivation rec {
  name = "servus-1.5.1";
  buildInputs = [ stdenv pkgconfig boost cmake doxygen avahi];

  src = fetchgit {
    url = "https://github.com/HBPVIS/Servus.git";  
    rev = "eee5765";
    sha256 = "1d1k72b3z0ibm1jfhzvb08ryk32kxahy6fsjrjsm2pi58bfx1a63";
  };
  

  enableParallelBuilding = true;
}




