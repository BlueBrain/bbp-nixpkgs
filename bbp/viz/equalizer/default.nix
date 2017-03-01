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
    rev = "7fbb0449aed2988c3806bc2b5d75070680ee7dbe";
    sha256 = "0d1han5l8a6sw9imk2s83khrrl6lawsl27sh6cbijkgagjafix8h";
  };


  # need to have the lib directory in LDPATH for binary creation 
  preBuild = ''
	export LD_LIBRARY_PATH="''${PWD}/lib:''${LDLIBRARY_PATH}"
  '';

#  patches = [ ./frame_data.patch ];

  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox pression collage hwsd vmmlib ];
  
}


