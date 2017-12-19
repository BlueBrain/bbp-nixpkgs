{ stdenv
, config
, fetchgitPrivate
, pkgconfig
, boost
, cmake
, zeromq
, cppzmq
, pythonPackages
 }:

let
	jarvis_src = fetchgitPrivate {
	  url = config.inait_git_ssh + "/INFRA/Jarvis.git";
	  rev = "3e13a1b7d653c0b811a4df2e7fb18a1a84375262";
	  sha256 = "09w2il092kcnypgxwippnirj99g1hvp2mx6h5hri5x93anyklfh2";
	};
	
	jarvis_version = "0.2";

	pyjarvis = pythonPackages.buildPythonPackage rec {
	  name = "pyjarvis-${version}";
	  version = jarvis_version;

	  src = jarvis_src;

	  propagatedBuildInputs = [ pythonPackages.pyzmq ];
	  
	};
	
	server = stdenv.mkDerivation rec {
	  name = "jarvis-${version}";
	  version = jarvis_version;
		
	  src = jarvis_src;
		
	  buildInputs = [ cmake boost pkgconfig zeromq cppzmq ];
	
	};
	
in {
	pyjarvis = pyjarvis;
	server = server;
}


