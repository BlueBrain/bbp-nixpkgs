{ stdenv, fetchgitExternal, cmake,  boost, pkgconfig, doxygen }:

stdenv.mkDerivation rec {
  name = "servus-1.1.0-stable";
  buildInputs = [ stdenv pkgconfig boost cmake doxygen];

  src = fetchgitExternal {
    url = "https://github.com/HBPVIS/Servus.git";  
    rev = "0a5c5e4aeb6479e4ed6346b0aa9197a14d38afa4";
    sha256 = "000whyg90wcgzhlrrg1b81ln8kjg25z56qm0jsaiab0qir3dgb6q";
  };
  

  enableParallelBuilding = true;
}




