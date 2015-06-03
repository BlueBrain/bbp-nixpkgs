{ stdenv, boost, fetchgit, cmake, bbp-cmake, mpich2, servus, pkgconfig, leveldb, doxygen }:

stdenv.mkDerivation rec {
  name = "lunchbox-1.12.0.0DEV";
  buildInputs = [ stdenv boost pkgconfig bbp-cmake servus mpich2 cmake leveldb doxygen];

  src = fetchgit {
    url = "https://github.com/Eyescale/Lunchbox.git";
    
    rev = "99a20c215491be4839acd40b31565c0f02c93334";
    sha256 = "1x0cpl6igljsvrg0ii61qm3qcdvnmbx9565dx8h182v9g8ymphh4";
  };
  
  patchPhase= ''
	ln -s ${bbp-cmake}/share/bbp-cmake/Common CMake/common
  '';
    

  enableParallelBuilding = true;
  
}



