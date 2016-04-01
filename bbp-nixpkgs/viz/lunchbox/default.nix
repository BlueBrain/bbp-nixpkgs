{ stdenv, boost, fetchgitExternal, cmake, servus, pkgconfig, leveldb, doxygen }:

stdenv.mkDerivation rec {
  name = "lunchbox-1.12.0";
  buildInputs = [ stdenv boost pkgconfig servus cmake leveldb doxygen];

  src = fetchgitExternal{
    url = "https://github.com/Eyescale/Lunchbox.git";
    rev = "01caa155d89e9f56318319fd236be1b0bfc1ed03";
    sha256 = "0s1w1ds3z6gf1hyns14cv12xd854y7xsswsflzph0hh8cavyr83s";
  };
  
  enableParallelBuilding = true;
  
}



