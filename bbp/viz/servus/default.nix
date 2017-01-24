{ stdenv, fetchgitExternal, cmake,  boost, pkgconfig, doxygen, avahi ? null }:

stdenv.mkDerivation rec {
  name = "servus-1.4.0";
  buildInputs = [ stdenv pkgconfig boost cmake doxygen avahi];

  src = fetchgitExternal {
    url = "https://github.com/HBPVIS/Servus.git";  
    rev = "2da95eab05b830d224f44a6d8a0a91f06ea8e534";
    sha256 = "11dgwmjd9pcnz3py761ibsfivk9yivkh30v40pgydilrp6gm5f20";
  };
  

  enableParallelBuilding = true;
}




