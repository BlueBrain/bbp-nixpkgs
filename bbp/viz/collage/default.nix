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
    rev = "3f00a90b48f699b2ab4fa79df209c34c1bd34a38";
    sha256 = "1lks7gargcynn2qjl3k9xs9yn9yz779534isfhx3llmhpir6v8xi";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox pression ];
  
}


