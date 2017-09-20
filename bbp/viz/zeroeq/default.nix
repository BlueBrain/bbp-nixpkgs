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
    sha256 = "17hg2ba6apq0vl7hg3g8vy6vggcn9fjp87im7b8xv7xrbjkwlr8y";
  };
  
  propagatedBuildInputs = [ servus ];

  enableParallelBuilding = true;

}



