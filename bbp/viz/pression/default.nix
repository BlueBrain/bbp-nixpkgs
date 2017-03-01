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
    rev = "ae3dded3da8b5aded1f6193d3da08acaf210f944";
    sha256 = "0sa23q4cwgnq4zv5zbaxfp13z99568ypzp37xwbdjcw1jgm3x03w";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox ];
   
}


