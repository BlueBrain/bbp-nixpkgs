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
    rev = "ef4fa3effeae11c717073bf088a9b5dabd22f779";
    sha256 = "11yg34fnh0f2yfpr471b4c5v4clqkg9a6sy760l9silabh9mmyxj";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ openscenegraph opengl ];
  
}


