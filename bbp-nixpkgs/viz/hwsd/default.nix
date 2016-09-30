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
    rev = "04c7cd9cc4398675d483f791e478946905ea385f";
    sha256 = "1h7n21jqzsfq9bhriwdijp0v51l0bm9dxhhmsi0sffr57abjamhi";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox opengl ];
  
}


