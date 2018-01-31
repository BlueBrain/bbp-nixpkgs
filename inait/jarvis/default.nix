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
	  rev = "974758b4661af322bcd2c3a259b5bf1654fd90f5";
	  sha256 = "13q9hba0k3v5dk5hydh5vg98fmw3l76zvi3jmjdcv0zcxv1zadrj";
	};
	
	jarvis_version = "0.2";

	pyjarvis = pythonPackages.buildPythonPackage rec {
	  name = "pyjarvis-${version}";
	  version = jarvis_version;

	  src = jarvis_src;

	  propagatedBuildInputs = [ pythonPackages.pyzmq4 ];
	  
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


