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
    rev = "ce76c9ca4f8cd83d470d46023af2c75323c2c7b0";
    sha256 = "1irq44cab4pihyfxna3ljlr9sdkin7vi6z5c92b34lx4vac0813l";
  };
  
  propagatedBuildInputs = [ servus ];

  enableParallelBuilding = true;

}



