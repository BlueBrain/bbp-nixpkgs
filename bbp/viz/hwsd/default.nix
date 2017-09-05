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
    sha256 = "0r421a4bl4ib529xqj2xvsa91c3zjy857plfv02akwz13ihsrfv0";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox opengl ];
  
}


