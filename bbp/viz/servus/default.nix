{ stdenv, fetchgit, cmake,  boost, pkgconfig, doxygen, avahi ? null }:

stdenv.mkDerivation rec {
  name = "servus-${version}";
  version= "1.6.0-dev201710";

  buildInputs = [ stdenv pkgconfig boost cmake doxygen avahi];

  src = fetchgit {
    url = "https://github.com/HBPVIS/Servus.git";  
    rev = "170bd93dbdd6c0dd80cf4dfc5926590cc5cef5ab";
    sha256 = "1v6lpkaq32sk3q944irpxh7s73qw8q3mca9p2ni7nf5a5iibgy8c";
  };
  

  enableParallelBuilding = true;
}




