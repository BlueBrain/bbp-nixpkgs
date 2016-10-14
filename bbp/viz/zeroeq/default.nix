{ stdenv
, fetchgitExternal
, cmake
, servus
, pkgconfig
, httpxx
, zeromq
, boost 
}:


stdenv.mkDerivation rec {
  name = "zeroeq-${version}";
  version = "0.6.0-2016-10";

  buildInputs = [ stdenv pkgconfig servus cmake boost httpxx zeromq ];



  src = fetchgitExternal{
    url = "https://github.com/HBPVIS/ZeroEQ.git";
    rev = "1ff42dc1441260615ae93e89f254f5a40077b7df";
    sha256 = "0lczv7baq5kmpb4naknvq0bgiwbapp1fdj9aqsn5zax9j6sxhjwd";
  };
  
  preConfigure = ''
			export CFLAGS="-fPIC $CFLAGS"
			export CPPFLAGS="-fPIC $CPPFLAGS"
			export CXXFLAGS="-fPIC $CXXFLAGS"
  '';

  makeFlags = [ "VERBOSE=1" ];


  enableParallelBuilding = true;

}



