{ stdenv
, config
, fetchgitPrivate
, pkgconfig
, boost
, cmake
, mvdtool
, pythonPackages
 }:

let
    # create a python environment with every dep, for the cmd line tool itself
    python_env = pythonPackages.python.buildEnv.override {
        extraLibs = [ pythonPackages.numpy pythonPackages.rtree mvdtool ];
    };

in

pythonPackages.buildPythonPackage rec {
  name = "neuroconnector-${version}";
  version = "1.0";
  
  buildInputs = [ stdenv mvdtool pythonPackages.numpy pythonPackages.rtree ];
  nativeBuildInputs = [ python_env ];

  src = fetchgitPrivate {
    url = config.inait_git_ssh + "/SIMULATION/neuroconnector.git";
    rev = "6e242d8ef799d87f21c63002424a6de37667a98d";
    sha256 = "1wyirmwqmr6cwia4n226c6wsar1y8irp79rsvff29ln38q4xi8fv";
  };
  
  propagatedBuildInputs = [ mvdtool pythonPackages.numpy pythonPackages.rtree ];
  
}


