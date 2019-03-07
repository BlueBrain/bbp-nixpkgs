{ stdenv, fetchgit, cmake,  boost, pkgconfig, doxygen, avahi ? null }:

stdenv.mkDerivation rec {
  name = "servus-${version}";
  version= "1.6.0-dev201710";

  buildInputs = [ stdenv pkgconfig boost cmake doxygen avahi];

  src = fetchgit {
    url = "https://github.com/HBPVIS/Servus.git";  
    rev = "25b7f39126dbe5036606ef431658bc6691a7de61";
    sha256 = "07c53v7m57dycwm7wiixbmyqv8ndxahw7jlzw1707n4h8fdjbwba";
  };
  

  enableParallelBuilding = true;
}




