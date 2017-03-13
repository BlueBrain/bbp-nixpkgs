{ stdenv, 
fetchgitExternal, 
boost, 
cmake, 
pkgconfig, 
lunchbox,
pression
 }:

stdenv.mkDerivation rec {
  name = "collage-${version}";
  version = "1.6";

  buildInputs = [ stdenv pkgconfig boost cmake lunchbox pression ];

  src = fetchgitExternal {
    url = "https://github.com/Eyescale/Collage.git";
    rev = "206860e068a90acd1cd9942f984a35831b987919";
    sha256 = "18nf47hlz8j59qyr3ph52pg6c4r11ibfhhp8xf92n3phlfv77hsr";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox pression ];
  
}


