{ stdenv, 
fetchgitPrivate,
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

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/viz/osgTransparency";
    rev = "e776367";
    sha256 = "0iiyasg1c4lgwkmyrpbsgdhj9dhm3grv6fac8vwf1gvdmdq1f5na";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ openscenegraph opengl ];
  
}


