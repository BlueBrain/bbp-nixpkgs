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
  version = "1.7-dev201708";

  buildInputs = [ stdenv pkgconfig boost cmake lunchbox pression ];

  src = fetchgit {
    url = "https://github.com/Eyescale/Collage.git";
    rev = "e2bc13dc2f85535e1f8caeb13f53b62c2bacb734";
    sha256 = "0vnk8i4ys3vw1xjkmn32hrf6sngpz16vih6pjwsxwsl75g03j897";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox pression ];
  
}


