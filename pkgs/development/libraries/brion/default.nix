{ stdenv, fetchgit, boost, cmake, bbp-cmake, servus, lunchbox, vmmlib, cppcheck, pkgconfig, hdf5, zlib, doxygen }:

stdenv.mkDerivation rec {
  name = "brion-1.5.0.0DEV";
  buildInputs = [ stdenv pkgconfig boost cmake servus lunchbox vmmlib hdf5 zlib doxygen cppcheck];

  src = fetchgit {
    url = "https://github.com/BlueBrain/Brion.git";
    
    rev = "609152af51661fddc1e4df49ac644c9de24afd5e";
    sha256 = "1rswxmcivr1vj3ikyzwlcz97292xg6siclygcj1s3rq1xwvw34f9";
  };

  enableParallelBuilding = true;
  
# patch phase include common cmake and 
# disable functional tests  
# fix HDF5 detect issues
 
  patchPhase= ''
	ln -s ${bbp-cmake}/share/bbp-cmake/Common CMake/common &&
	sed -i 's@add_subdirectory(tests)@@g' CMakeLists.txt &&
	echo 'set(HDF5_hdf5_cpp_LIBRARY	"WeDontCARE")' >> CMakeLists
  '';  
  
  
}


