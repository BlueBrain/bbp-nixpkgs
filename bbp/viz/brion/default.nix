{ stdenv, 
fetchgitExternal, 
boost, 
cmake, 
servus, 
lunchbox, 
keyv,
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
  version = "1.9.0";

  buildInputs = [ stdenv pkgconfig 
				  mvdtool boost 
				  python pythonPackages.numpy 
				  cmake vmmlib servus lunchbox keyv hdf5-cpp zlib doxygen ];

  src = fetchgitExternal {
    url = "https://github.com/BlueBrain/Brion.git";
    rev = "e9ab6bf1c7458562ad126142a2761faff73a2e41";
    sha256 = "0hfipsjfl17a4x0mwalyzyddmfxb5z4fazahawzw6rid21r5h193";
  };


  enableParallelBuilding = true;

  ## horrible hack to disable the -WError maddness
  ##
  cmakeFlags = "-DXCODE_VERSION=1";

  propagatedBuildInputs = [ lunchbox vmmlib boost ];
   
}


