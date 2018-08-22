{ stdenv, fetchgit, cmake,  boost, pkgconfig, doxygen, avahi ? null }:

stdenv.mkDerivation rec {
  name = "servus-${version}";
  version= "1.6.0-dev201710";

  buildInputs = [ stdenv pkgconfig boost cmake doxygen avahi];

  src = fetchgit {
    url = "https://github.com/HBPVIS/Servus.git";  
    rev = "574bc705ed24eb004a1649da220c7c29c9769995";
    sha256 = "00z0naggar1fymfaaj5kyyxsr634sc2az65l507jngxzm8cfndnc";
  };
  

  enableParallelBuilding = true;
}




