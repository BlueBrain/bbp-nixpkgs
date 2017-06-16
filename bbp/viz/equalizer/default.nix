{ stdenv, 
fetchgit, 
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
  version = "2.1.0";

  buildInputs = [ stdenv pkgconfig boost bison flex hwloc x11 cmake lunchbox pression collage opengl hwsd vmmlib qt ];

  src = fetchgit {
    url = "https://github.com/Eyescale/Equalizer.git";
    rev = "a3affbd";
    sha256 = "0hn8p3mng9d9m8ba5qcq8b97lhr1l0f2xh0pdpkm3g4k4saaf370";
  };


  # need to have the lib directory in LDPATH for binary creation 
  preBuild = ''
	export LD_LIBRARY_PATH="''${PWD}/lib:''${LDLIBRARY_PATH}"
  '';


  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox pression collage hwsd vmmlib ];
  
}


