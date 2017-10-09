{ stdenv, fetchgit, cmake,  boost, pkgconfig, doxygen, avahi ? null }:

stdenv.mkDerivation rec {
  name = "servus-${version}";
  version= "1.6.0-dev201710";

  buildInputs = [ stdenv pkgconfig boost cmake doxygen avahi];

  src = fetchgit {
    url = "https://github.com/HBPVIS/Servus.git";  
    rev = "8d47578a7b738432f294b12af80aa9c9d9080df0";
    sha256 = "033f2jjkfzaw66nafhgyf1qry8bjbsk3f4plzkhrdhv7hf6kgb18";
  };
  

  enableParallelBuilding = true;
}




