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
  version = "0.8.0-2017.06";

  buildInputs = [ stdenv pkgconfig servus cmake boost zeromq openssl ];



  src = fetchgit {
    url = "https://github.com/HBPVIS/ZeroEQ.git";
    rev = "1949f24";
    sha256 = "13y4ja0abavpy5myfsdy7wdvhz9fbb8fqz4d3ah97ibck2kqrg19";
  };
  
  propagatedBuildInputs = [ servus ];

  enableParallelBuilding = true;

}



