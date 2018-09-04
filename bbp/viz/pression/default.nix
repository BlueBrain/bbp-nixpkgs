{ stdenv, 
fetchgit, 
boost, 
cmake, 
pkgconfig, 
lunchbox
 }:

stdenv.mkDerivation rec {
  name = "pression-${version}";
  version = "latest";

  buildInputs = [ stdenv pkgconfig boost cmake lunchbox];

  src = fetchgit {
    url = "https://github.com/Eyescale/Pression.git";
    rev = "810996a2c3c4bdfd1bb5b4ae2a13ce46e8620620";
    sha256 = "0kqz90hyl08rlqd8qq5pj8zqcpj9llr78kbhfqpbmi02lmgci1y1";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox ];
   
}


