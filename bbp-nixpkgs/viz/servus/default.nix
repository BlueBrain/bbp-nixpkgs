{ stdenv, fetchgitExternal, cmake,  boost, pkgconfig, doxygen, avahi ? null }:

stdenv.mkDerivation rec {
  name = "servus-1.4.0";
  buildInputs = [ stdenv pkgconfig boost cmake doxygen avahi];

  src = fetchgitExternal {
    url = "https://github.com/HBPVIS/Servus.git";  
    rev = "5afd636b117aa3b046bf06ae5864ec1ce5e4e497";
    sha256 = "0rfanhxwr61q3q8mkfnd3xfv2v254zffkzg518b7cdrhhsfaa9fx";
  };
  

  enableParallelBuilding = true;
}




