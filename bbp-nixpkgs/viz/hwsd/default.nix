{ stdenv, 
fetchgitExternal, 
boost, 
cmake, 
pkgconfig, 
lunchbox,
opengl,
x11
}:

stdenv.mkDerivation rec {
  name = "hwsd-${version}";
  version = "1.4.0";

  buildInputs = [ stdenv pkgconfig boost cmake lunchbox opengl x11 ];

  src = fetchgitExternal {
    url = "https://github.com/Eyescale/hwsd.git";
    rev = "334e191618678c74767b6228a7db5a8c520aec54";
    sha256 = "06l4vzxy0fs51psksgfdzmhfw1qkc77cpxga4hsw2xd5k02l9qb4";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox opengl ];
  
}


