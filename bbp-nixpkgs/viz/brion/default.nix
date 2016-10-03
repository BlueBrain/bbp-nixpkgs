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
    rev = "0877e10f589e49682d5164886d7518cafac197a6";
    sha256 = "0gl1znigwahivxwc9ymqp5sf4l928kvs452323k42nfk8pvnbfxg";
	fetchSubmodules = true;
  };


  enableParallelBuilding = true;

  ## horrible hack to disable the -WError maddness
  ##
  cmakeFlags = "-DXCODE_VERSION=1";
   
}


