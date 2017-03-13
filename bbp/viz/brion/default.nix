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
  version = "2.0-2017.02";

  buildInputs = [ stdenv pkgconfig 
				  mvdtool boost 
				  python pythonPackages.numpy 
				  cmake vmmlib servus lunchbox keyv hdf5-cpp zlib doxygen ];

  src = fetchgitExternal {
    url = "https://github.com/BlueBrain/Brion.git";
    rev = "8b0c1f1acf56cd03f889390f3c57cb845d68bee2";
    sha256 = "18w98yylan1frvbc38s12isffm765i8jd6zfv72hqmxaw1nmjaaq";
  };


  enableParallelBuilding = true;


  propagatedBuildInputs = [ lunchbox vmmlib boost ];
   
}


