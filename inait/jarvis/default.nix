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
	  rev = "cad0e9c42954b8d57af4bb32b350b85048eb4800";
	  sha256 = "0h3fgkk9wajxvyp95gz4i87kw87xmg66gnd5ysbybclrp1hag672";
	};
	
	jarvis_version = "1.5dev";

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


