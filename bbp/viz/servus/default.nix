{ stdenv, fetchgit, cmake,  boost, pkgconfig, doxygen, avahi ? null }:

stdenv.mkDerivation rec {
  name = "servus-${version}";
  version= "1.5.1-dev201708";

  buildInputs = [ stdenv pkgconfig boost cmake doxygen avahi];

  src = fetchgit {
    url = "https://github.com/HBPVIS/Servus.git";  
    rev = "7a60583ad1bb337b9a8b3a8b006e7a342cd57fa4";
    sha256 = "1f5ciqd89xvvs349wwayyx291micwk9x768y5wlk4nz0lr4nk8j8";
  };
  

  enableParallelBuilding = true;
}




