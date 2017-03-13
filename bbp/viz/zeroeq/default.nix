{ stdenv
, fetchgitExternal
, cmake
, servus
, pkgconfig
, httpxx
, zeromq
, boost 
, openssl
}:


stdenv.mkDerivation rec {
  name = "zeroeq-${version}";
  version = "0.7.-2017.02";

  buildInputs = [ stdenv pkgconfig servus cmake boost httpxx zeromq openssl ];



  src = fetchgitExternal{
    url = "https://github.com/HBPVIS/ZeroEQ.git";
    rev = "73b209a16b06f25d604883228e39c1806b328f59";
    sha256 = "1323f53j30c0qs0rn75hk49cd9hw1143q9m2p5hfy9ags5vqs51f";
  };
  
  preConfigure = ''
			export CFLAGS="-fPIC $CFLAGS"
			export CPPFLAGS="-fPIC $CPPFLAGS"
			export CXXFLAGS="-fPIC $CXXFLAGS"
  '';

  
  cmakeFlags = [ "-DBOOST_ROOT=${boost}" ];

  makeFlags = [ "VERBOSE=1" ];


  enableParallelBuilding = true;

}



