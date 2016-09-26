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
    rev = "8ce1a32d58f671a175d0c2671aab650d58405c80";
    sha256 = "0884j6sis5k76j6pj34dkgpcjpksd11wy670a6zz443nk4rasbc6";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox ];
   
}


