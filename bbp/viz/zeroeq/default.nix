{ stdenv
, fetchgit
, cmake
, servus
, pkgconfig
, zeromq
, boost 
, openssl
}:


stdenv.mkDerivation rec {
  name = "zeroeq-${version}";
  version = "0.9.0-201710";

  buildInputs = [ stdenv pkgconfig servus cmake boost zeromq openssl ];



  src = fetchgit {
    url = "https://github.com/HBPVIS/ZeroEQ.git";
    rev = "1e66ee32846ac6e966eefe39c1c07fb376031880";
    sha256 = "1mxh2ql65aamc9b561p8r8vj6fwkf3f9xd3ml0v1krn58xxnbipq";
  };
  
  propagatedBuildInputs = [ servus ];

  enableParallelBuilding = true;

}



