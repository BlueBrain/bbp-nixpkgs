{ fetchgitPrivate
, config
, stdenv
, boost
, cmake
, hdf5-cpp
, vtk }:

stdenv.mkDerivation rec {
  name = "morphsyn-${version}";
  version = "9040c";
  buildInputs = [ stdenv boost cmake hdf5-cpp vtk ];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/algorithms/synthesis/morphsyn";
    rev = "9040c21a7094f906884b6e2883435b0e07283bab";
    sha256 = "0i5zb94k0wizqqqn517x76vvwm1vyc258vf0c8431365wzvhq5g4";
  };
}
