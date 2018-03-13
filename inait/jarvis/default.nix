{ stdenv
, config
, fetchgitPrivate
, pkgconfig
, boost
, cmake
, zeromq
, rocksdb
, cppzmq
, pythonPackages
 }:

let
	jarvis_src = fetchgitPrivate {
	  url = config.inait_git_ssh + "/INFRA/Jarvis.git";
	  rev = "9c60169567736d6ddb314cf93d0e9f50985294bc";
	  sha256 = "1vc5wlzk9jlq2y3nz4407qywsj5gjxlyqbnnyvsxzlnzsdcsih1s";
	};
	
	jarvis_version = "1.4dev";

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
		
	  buildInputs = [ cmake boost rocksdb pkgconfig zeromq cppzmq ];

	  postInstall = ''
		mkdir -p $out/share/jarvis/config
		cp ../config/jarvis_inait.toml $out/share/jarvis/config
	  '';

	 doCheck = true;
         checkPhase = '' ctest -V ''; 
	
	};
	
in {
	pyjarvis = pyjarvis;
	server = server;
}


