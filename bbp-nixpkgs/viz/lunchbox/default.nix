{ stdenv, boost, fetchgitExternal, cmake, servus, pkgconfig, leveldb, doxygen }:

stdenv.mkDerivation rec {
  name = "lunchbox-1.12.0";
  buildInputs = [ stdenv boost pkgconfig servus cmake leveldb doxygen];

  src = fetchgitExternal{
    url = "https://github.com/Eyescale/Lunchbox.git";
    rev = "30b8b8ebeace6a9e0d9375af3e72ce6ba333e9ce";
    sha256 = "02haqp5xybv87ahrgzj2zsn4ybq7mgjja2lxsd37wz0knwn5js2f";
  };
  
  enableParallelBuilding = true;
  
}



