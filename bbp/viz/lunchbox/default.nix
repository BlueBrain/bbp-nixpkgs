{ stdenv, boost, fetchgitExternal, cmake, servus, pkgconfig, leveldb, doxygen }:

stdenv.mkDerivation rec {
  name = "lunchbox-1.12.0";
  buildInputs = [ stdenv boost pkgconfig servus cmake leveldb doxygen];

  src = fetchgitExternal{
    url = "https://github.com/Eyescale/Lunchbox.git";
    rev = "b86aeb35757b54ca662b880be64dbb14214efdde";
    sha256 = "16xxk1722lh7n78qjavzjigjjkirnnl8gdgpxra48xchlmvjlpbk";
  };
  
  enableParallelBuilding = true;

  propagatedBuildInputs = [ servus ];
  
}



