{ stdenv, 
fetchurl, 
pkgconfig, 
boost, 
bbpsdk, 
brion,
lunchbox, 
vmmlib,
servus,
cmake, 
bbp-cmake, 
mpich2, 
zlib, 
python, 
numpy,
hdf5, 
doxygen }:

stdenv.mkDerivation rec {
  name = "flatindexer-1.7.0.0.TRUNK";
  buildInputs = [ stdenv pkgconfig boost cmake bbp-cmake bbpsdk brion lunchbox vmmlib servus zlib python numpy hdf5 doxygen];

  src = fetchurl {
    url = "https://owncloud.adev.name/public.php?service=files&t=9a57afeb6d7acf1c89ba69cf4451c018&download";
    name = "flatindexer-1.7.0.tar.gz";
    curlOpts = "-k";
    sha256 = "15qsaa8qzyx9s12d431p1k3mzi8685gfqx337sr7dnh3sd4kz1l4";
  };
  
  
  patchPhase= ''
	ln -s ${bbp-cmake}/share/bbp-cmake/Common CMake/common &&
	rm -rf \.gitsubprojects &&
	rm -rf \.gitexternals
	'';
	
  cmakeFlags="-DFLAT_PYTHON=OFF";

  enableParallelBuilding = true;
}


