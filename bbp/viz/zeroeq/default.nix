{ stdenv
, fetchgitExternal
, cmake
, servus
, pkgconfig
, httpxx
, zeromq
, boost 
, openssl
, cppnetlib
}:


stdenv.mkDerivation rec {
  name = "zeroeq-${version}";
  version = "0.6.0-2016-10";

  buildInputs = [ stdenv pkgconfig servus cmake boost httpxx zeromq openssl cppnetlib ];



  src = fetchgitExternal{
    url = "https://github.com/adevress/ZeroEQ.git";
    rev = "5248ae1af4add18dae496c80e20116714580c7f6";
    sha256 = "0bynw78chq1ss8wg687q8ffb06pa1sbwv0i6f1g5q5al6jzd6wxi";
  };
  
  preConfigure = ''
			export CFLAGS="-fPIC $CFLAGS"
			export CPPFLAGS="-fPIC $CPPFLAGS"
			export CXXFLAGS="-fPIC $CXXFLAGS"
  '';

  
  cmakeFlags = [ "-DZEROEQ_USE_EXTERNAL_CPPNETLIB=TRUE" ];

  makeFlags = [ "VERBOSE=1" ];


  enableParallelBuilding = true;

}



