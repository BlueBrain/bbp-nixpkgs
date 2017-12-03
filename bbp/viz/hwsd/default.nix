{ stdenv, 
fetchgit, 
boost, 
cmake, 
pkgconfig, 
lunchbox,
opengl,
x11
}:

stdenv.mkDerivation rec {
  name = "hwsd-${version}";
  version = "2.0.1-dev201708";

  buildInputs = [ stdenv pkgconfig boost cmake lunchbox opengl x11 ];

  src = fetchgit {
    url = "https://github.com/Eyescale/hwsd.git";
    rev = "03b6581561b5c7a8cdb9eba4c2c4f5fe83f0d41c";
    sha256 = "0hdrhg7ldd3c5qfn71spxk0b4n2r8qia8asnraxgn07gnjn0scdv";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox opengl ];
  
}


