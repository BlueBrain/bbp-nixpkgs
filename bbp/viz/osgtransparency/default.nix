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
          rev = "b2d9377d6a8d5b7d521d1afb0a6bae6e941f8e23";
          sha256 = "055vb7kn9hll2pwq93mdghv7wy1dxwwa3acvq0fszbswckks1w0d";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ openscenegraph opengl ];

}


