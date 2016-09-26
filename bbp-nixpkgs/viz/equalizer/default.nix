{ stdenv, 
fetchgitExternal, 
boost, 
cmake, 
bison,
flex,
hwloc, 
x11, 
pkgconfig, 
lunchbox,
vmmlib,
pression,
collage,
opengl,
hwsd,
qt
 }:

stdenv.mkDerivation rec {
  name = "equalizer-${version}";
  version = "1.13.0";

  buildInputs = [ stdenv pkgconfig boost bison flex hwloc x11 cmake lunchbox pression collage opengl hwsd vmmlib qt ];

  src = fetchgitExternal {
    url = "https://github.com/Eyescale/Equalizer.git";
    rev = "2949626596bb9d4fe4cb49e965d3a4dfc44580dc";
    sha256 = "02jpzswg8rk32v3qk5jjfxx2k3ym5q5p2ijf7zjznncf11gwqby1";
  };

  # need to have the lib directory in LDPATH for binary creation 
  preBuild = ''
	export LD_LIBRARY_PATH="''${PWD}/lib:''${LDLIBRARY_PATH}"
  '';

  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox pression collage hwsd vmmlib ];
  
}


