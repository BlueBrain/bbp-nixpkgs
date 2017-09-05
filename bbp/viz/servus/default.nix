{ stdenv, fetchgit, cmake,  boost, pkgconfig, doxygen, avahi ? null }:

stdenv.mkDerivation rec {
  name = "servus-${version}";
  version= "1.5.1-dev201708";

  buildInputs = [ stdenv pkgconfig boost cmake doxygen avahi];

  src = fetchgit {
    url = "https://github.com/HBPVIS/Servus.git";  
    rev = "7a60583ad1bb337b9a8b3a8b006e7a342cd57fa4";
    sha256 = "1vdlkgv3xmv8jqi13vfq3r34gsxchfmzyrvxc3lyz8i880lcm90x";
  };
  

  enableParallelBuilding = true;
}




