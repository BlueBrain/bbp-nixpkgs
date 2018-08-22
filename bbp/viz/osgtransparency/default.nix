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
  version = "0.8.0-dev201708";

  buildInputs = [ stdenv pkgconfig boost cmake openscenegraph ];

  src = fetchgit {
          url  = "https://github.com/BlueBrain/osgTransparency.git";
          rev = "cfbf3369bf67eb556ebeb834b9794b9c9f7ad4e0";
          sha256 = "18z3hah8r9bzp9l1j696a5niwf27bpvva86wldqkmv0f5c1x5l1x";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ openscenegraph opengl ];

}


