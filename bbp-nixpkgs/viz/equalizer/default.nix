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
    rev = "cc86c17b3022c07c4e51f9100ae5c32cd7df35e0";
    sha256 = "1gbk8yva5mb4919lzii7dm78kd8p2ch87mqnzjy1fshb9zvxp8xz";
  };

  patches  = [ ./qt.patch ];

  # need to have the lib directory in LDPATH for binary creation 
  preBuild = ''
	export LD_LIBRARY_PATH="''${PWD}/lib:''${LDLIBRARY_PATH}"
  '';

  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox pression collage hwsd vmmlib ];
  
}


