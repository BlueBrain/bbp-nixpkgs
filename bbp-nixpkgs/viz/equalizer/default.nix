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
    rev = "bf0ba1a2786e05bd10c6e8555f7df12cf416817f";
    sha256 = "0vz43jbjibhjmg5mvp2mkzr2h8c4r0vifqb944vnvqrnn51iks1q";
  };

  # need to have the lib directory in LDPATH for binary creation 
  preBuild = ''
	export LD_LIBRARY_PATH="''${PWD}/lib:''${LDLIBRARY_PATH}"
  '';

  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox pression collage hwsd vmmlib ];
  
}


