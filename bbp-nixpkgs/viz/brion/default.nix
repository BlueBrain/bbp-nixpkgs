{ stdenv, fetchgit, boost, cmake, cmake-external, servus, lunchbox, vmmlib, cppcheck, pkgconfig, hdf5-cpp, zlib, doxygen }:

stdenv.mkDerivation rec {
  name = "brion-1.6.0-DEV";
  buildInputs = [ stdenv pkgconfig boost cmake cmake-external servus lunchbox vmmlib hdf5-cpp zlib doxygen cppcheck];

  src = fetchgit {
    url = "https://github.com/BlueBrain/Brion.git";
    rev = "8e3b87ef49b7ec18fb8173f3d0335b6475ca1d0c";
    sha256 = "0flvmpmwsnky0k7rjyha2vy6gbvwgk505b4c4khyx243camwxaxm";
    deepClone = true;
  };


  enableParallelBuilding = true;
    
}


