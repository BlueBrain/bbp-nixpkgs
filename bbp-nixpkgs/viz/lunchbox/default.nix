{ stdenv, boost, fetchgitExternal, cmake, servus, pkgconfig, leveldb, doxygen }:

stdenv.mkDerivation rec {
  name = "lunchbox-1.12.0";
  buildInputs = [ stdenv boost pkgconfig servus cmake leveldb doxygen];

  src = fetchgitExternal{
    url = "https://github.com/Eyescale/Lunchbox.git";
    rev = "01caa155d89e9f56318319fd236be1b0bfc1ed03";
    sha256 = "1hh58n3bn1qilmlwd74j5lx1kycd4j772g5slckf8aiy123ia6ya";
  };
  
  enableParallelBuilding = true;
  
}



