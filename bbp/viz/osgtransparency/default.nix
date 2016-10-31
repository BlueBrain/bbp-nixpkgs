{ stdenv, 
fetchgitExternal, 
pkgconfig,
boost, 
cmake, 
openscenegraph,
opengl
 }:

stdenv.mkDerivation rec {
  name = "osgTransparency-${version}";
  version = "0.8.0";

  buildInputs = [ stdenv pkgconfig boost cmake openscenegraph ];

  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/viz/osgTransparency";
    rev = "6cdf6f6e8025ed91d512e079879e13017a8b3db3";
    sha256 = "1h62zvh2168gwhp1lj6284zs9vhxg1p5016qhf9s3gbn7n3q1867";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ openscenegraph opengl ];
  
}


