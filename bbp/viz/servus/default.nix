{ stdenv, fetchgit, cmake,  boost, pkgconfig, doxygen, avahi ? null }:

stdenv.mkDerivation rec {
  name = "servus-${version}";
  version= "1.6.0-dev201710";

  buildInputs = [ stdenv pkgconfig boost cmake doxygen avahi];

  src = fetchgit {
    url = "https://github.com/HBPVIS/Servus.git";  
    rev = "2e9a23aa32c2fc3f5c517405b0ac6292cd09abdf";
    sha256 = "0w9ahjghs3p1yb8svzvpk2izzssigqjkcfhdxfhmzknclgv54qs6";
  };
  

  enableParallelBuilding = true;
}




