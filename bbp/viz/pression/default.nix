{ stdenv, 
fetchgit, 
boost, 
cmake, 
pkgconfig, 
lunchbox
 }:

stdenv.mkDerivation rec {
  name = "pression-${version}";
  version = "2.0.0";

  buildInputs = [ stdenv pkgconfig boost cmake lunchbox];

  src = fetchgit {
    url = "https://github.com/Eyescale/Pression.git";
    rev = "08cd4bf";
    sha256 = "1yskpxkzvcv8vxdklg83qhdbwkxdvighcxidx1940aq0p2iwgz61";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox ];
   
}


