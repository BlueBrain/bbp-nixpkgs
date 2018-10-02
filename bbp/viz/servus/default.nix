{ stdenv, fetchgit, cmake,  boost, pkgconfig, doxygen, avahi ? null }:

stdenv.mkDerivation rec {
  name = "servus-${version}";
  version= "1.6.0-dev201710";

  buildInputs = [ stdenv pkgconfig boost cmake doxygen avahi];

  src = fetchgit {
    url = "https://github.com/HBPVIS/Servus.git";  
    rev = "059f391a0d97ec14330ffd786457f333c0bd66da";
    sha256 = "0rqadw2y9rn6yaldfcm6jv0qk53xrh9mi2nr5n4p9z4fssqy3ssj";
  };
  

  enableParallelBuilding = true;
}




