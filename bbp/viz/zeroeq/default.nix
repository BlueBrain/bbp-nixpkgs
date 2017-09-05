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
  version = "0.8.0-dev201708";

  buildInputs = [ stdenv pkgconfig servus cmake boost zeromq openssl ];



  src = fetchgit {
    url = "https://github.com/HBPVIS/ZeroEQ.git";
    rev = "ed5ad57949cba799b21ab5eae039c27f61b935ba";
    sha256 = "1r2g7sifnv3fcl0n0cxbaypryb4pdj1xrnnpj6v0izgr5n95flr9";
  };
  
  propagatedBuildInputs = [ servus ];

  enableParallelBuilding = true;

}



