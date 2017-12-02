{ stdenv, 
fetchgit, 
boost, 
cmake, 
pkgconfig, 
lunchbox
 }:

stdenv.mkDerivation rec {
  name = "pression-${version}";
  version = "2.0.0-dev201708";

  buildInputs = [ stdenv pkgconfig boost cmake lunchbox];

  src = fetchgit {
    url = "https://github.com/Eyescale/Pression.git";
    rev = "08cd4bfb44795eb7373acd39f6e450a0968dae0b ";
    sha256 = "1wyx9g03bxap6jysa0jcxwk4pfibkz1nfwzdmj42la4g8lpj7cvb";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox ];
   
}


