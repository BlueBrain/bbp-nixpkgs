{ stdenv, 
fetchgit, 
boost, 
cmake, 
pkgconfig, 
lunchbox,
pression
 }:

stdenv.mkDerivation rec {
  name = "collage-${version}";
  version = "1.7";

  buildInputs = [ stdenv pkgconfig boost cmake lunchbox pression ];

  src = fetchgit {
    url = "https://github.com/Eyescale/Collage.git";
    rev = "f320324";
    sha256 = "19i6rx0i893vrkaxjczk2s0zarx09saz6qpjvx1b2hfimp8nn8jb";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox pression ];
  
}


