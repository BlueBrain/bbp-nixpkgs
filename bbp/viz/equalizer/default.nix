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
    rev = "0f893002e2283d3aa87d1b94024624e6040dbf95";
    sha256 = "088ii06lr0m1x2a9c6ahx78jn7s6y79dclq3bxp2l094wqmjg8wm";
  };

#  patches  = [ ./qt.patch ];

  # need to have the lib directory in LDPATH for binary creation 
  preBuild = ''
	export LD_LIBRARY_PATH="''${PWD}/lib:''${LDLIBRARY_PATH}"
  '';

  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox pression collage hwsd vmmlib ];
  
}


