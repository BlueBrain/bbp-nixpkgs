{ stdenv
, config
, fetchgit
, pkgconfig
, boost
, cmake
, openscenegraph
, opengl }:

stdenv.mkDerivation rec {
  name = "osgTransparency-${version}";
  version = "latest";

  buildInputs = [ stdenv pkgconfig boost cmake openscenegraph ];

  src = fetchgit {
          url  = "https://github.com/BlueBrain/osgTransparency.git";
          rev = "09f1a656b11802244936a1275d7e55dd7fc2dc7a";
          sha256 = "130j26gqcw7agl3li0sm0slfjs2mwxbv6d9prmlm7plnq365phqy";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ openscenegraph opengl ];

}


