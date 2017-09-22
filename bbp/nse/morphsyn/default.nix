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
    sha256 = "19j4qj65lz5qdfvzy1mbghd31xcjjp6xf4n581nw9vnipnd83j12";
  };
}
