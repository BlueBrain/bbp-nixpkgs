{ stdenv, fetchgit, cmake,  boost, pkgconfig, doxygen, avahi ? null }:

stdenv.mkDerivation rec {
  name = "servus-${version}";
  version= "1.6.0-dev201710";

  buildInputs = [ stdenv pkgconfig boost cmake doxygen avahi];

  src = fetchgit {
    url = "https://github.com/HBPVIS/Servus.git";  
    rev = "8a17770a7f55378cdfdfc834c78b52979577e659";
    sha256 = "185impjadyc0x4vqqq8b1k7bx4x0ssr5xvrgli1mnhlxcvfj7pla";
  };
  

  enableParallelBuilding = true;
}




