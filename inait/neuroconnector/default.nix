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
  version = "1.2";
  
  buildInputs = [ stdenv mvdtool pythonPackages.numpy pythonPackages.rtree ];
  nativeBuildInputs = [ python_env ];

  src = fetchgitPrivate {
    url = config.inait_git_ssh + "/SIMULATION/neuroconnector.git";
    rev = "188868ab0a4a3dc28051eabf74570ad8f28d528f";
    sha256 = "02nxv7z0jmvi52d6nanyfzm4m3y86n4kwjh82qnv3j8wjrccpdwa";
  };
  
  propagatedBuildInputs = [ mvdtool pythonPackages.numpy pythonPackages.rtree ];
  
}


