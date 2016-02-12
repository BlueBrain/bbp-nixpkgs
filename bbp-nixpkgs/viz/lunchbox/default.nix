{ stdenv, boost, fetchgit, cmake, cmake-external, servus, pkgconfig, leveldb, doxygen }:

stdenv.mkDerivation rec {
  name = "lunchbox-1.12.0";
  buildInputs = [ stdenv boost pkgconfig cmake-external servus cmake leveldb doxygen];

  src = fetchgit{
    url = "https://github.com/Eyescale/Lunchbox.git";
    rev = "01caa155d89e9f56318319fd236be1b0bfc1ed03";
    sha256 = "0n4jwkjlmz7hy6xb3jhrca2vm7hrpsbxpfqxlvrkm2hdw2x0a3rz";
    deepClone = true;
  };
  
  enableParallelBuilding = true;
  
}



