{ stdenv
, config
, fetchgitPrivate
, pkgconfig
, boost
, cmake
, mvdtool
, pythonPackages
 }:

pythonPackages.buildPythonPackage rec {
  name = "neuroconnector-${version}";
  version = "1.2";
  
  buildInputs = [ stdenv mvdtool pythonPackages.numpy pythonPackages.rtree ];

  src = fetchgitPrivate {
    url = config.inait_git_ssh + "/SIMULATION/neuroconnector.git";
    rev = "188868ab0a4a3dc28051eabf74570ad8f28d528f";
    sha256 = "02nxv7z0jmvi52d6nanyfzm4m3y86n4kwjh82qnv3j8wjrccpdwa";
  };
  
  propagatedBuildInputs = [ mvdtool pythonPackages.numpy pythonPackages.rtree ];
  
}


