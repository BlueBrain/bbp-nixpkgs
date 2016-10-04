{ stdenv, 
fetchgitExternal, 
boost, 
cmake, 
pkgconfig, 
lunchbox
 }:

stdenv.mkDerivation rec {
  name = "collage-${version}";
  version = "1.8";

  buildInputs = [ stdenv pkgconfig boost cmake lunchbox];

  src = fetchgitExternal {
    url = "https://github.com/Eyescale/Pression.git";
    rev = "9f50cf4b47f0606bc43c7128b15eb327bd73257e";
    sha256 = "01wa4ymjik285wh5pxj9x48xp1a82c7g9345xxwlr179v86klv0i";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox ];
   
}


