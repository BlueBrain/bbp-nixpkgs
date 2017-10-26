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
    rev = "4e2046afb4c219265150826781bb2d8af38b450a";
    sha256 = "2wyirmwqmr6cwia4n226c6wsar1y8irp79rsvff29ln38q4xi8fv";
  };
  
  propagatedBuildInputs = [ mvdtool pythonPackages.numpy pythonPackages.rtree ];
  
}


