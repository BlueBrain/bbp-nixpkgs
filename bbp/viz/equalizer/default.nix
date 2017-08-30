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
  version = "2.1.0-dev201708";

  buildInputs = [ stdenv pkgconfig boost bison flex hwloc x11 cmake lunchbox pression collage opengl hwsd vmmlib qt.base ];

  src = fetchgit {
    url = "https://github.com/Eyescale/Equalizer.git";
    rev = "21b3de02d39e30f14b9a15964a05240bcd28f553";
    sha256 = "1kpbig757h0a0n6vhwr097p65nahz24wv1v1iv9a0sv6dv40mshk";
  };


  # need to have the lib directory in LDPATH for binary creation 
  preBuild = ''
	export LD_LIBRARY_PATH="''${PWD}/lib:''${LDLIBRARY_PATH}"
  '';


  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox pression collage hwsd vmmlib ];
  
}


