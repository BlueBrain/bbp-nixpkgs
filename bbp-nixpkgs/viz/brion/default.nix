{ stdenv, 
fetchgitExternal, 
boost, 
cmake, 
servus, 
lunchbox, 
vmmlib,
pkgconfig, 
hdf5-cpp, 
zlib, 
mvdtool,
python,
pythonPackages,
doxygen }:

stdenv.mkDerivation rec {
  name = "brion-${version}";
  version = "1.8";

  buildInputs = [ stdenv pkgconfig 
				  mvdtool boost 
				  python pythonPackages.numpy 
				  cmake vmmlib servus lunchbox hdf5-cpp zlib doxygen ];

  src = fetchgitExternal {
    url = "https://github.com/BlueBrain/Brion.git";
    rev = "f9defb9eff8186dd2f05c7672a94e68a3ad9d23d";
    sha256 = "1gpb1bkvw5w8iz7bf8amn9ny7167nmdk4kd70lds5ngxvki2np7g";
  };


  enableParallelBuilding = true;

  ## horrible hack to disable the -WError maddness
  ##
  cmakeFlags = "-DXCODE_VERSION=1";
   
}


